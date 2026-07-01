import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:field_track/core/utils/dio_error_message.dart';
import 'package:field_track/features/todos/data/datasources/todo_local_datasource.dart';
import 'package:field_track/features/todos/data/datasources/todo_remote_datasource.dart';
import 'package:field_track/features/todos/domain/entities/pending_sync_todo.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';
import 'package:field_track/features/todos/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDatasource remote;
  final TodoLocalDatasource local;
  final Connectivity connectivity;

  final _reconnectController = StreamController<void>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasOffline = false;

  TodoRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  }) {
    _connectivitySub = connectivity.onConnectivityChanged.listen(_onConnectivity);
  }

  void _onConnectivity(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online && _wasOffline) {
      _reconnectController.add(null);
    }
    _wasOffline = !online;
  }

  @override
  Stream<void> watchReconnect() => _reconnectController.stream;

  Future<bool> _isOnline() async {
    final results = await connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  Future<List<Todo>> fetchAndCacheTodos() async {
    final models = await remote.fetchTodos();
    await local.upsertTodos(models);
    return local.getTodos();
  }

  @override
  Future<List<Todo>> getLocalTodos() => local.getTodos();

  @override
  Future<void> toggleTodo(String id, bool isCompleted) async {
    final now = DateTime.now().toUtc().toIso8601String();
    await local.updateTodoLocal(
      id: id,
      isCompleted: isCompleted,
      updatedAt: now,
      syncStatus: 'pending',
    );

    if (await _isOnline()) {
      try {
        await remote.patchTodo(
          id: id,
          isCompleted: isCompleted,
          updatedAt: now,
        );
        await local.markSynced(id);
        await local.removeFromQueue(id);
        await local.setLastSyncedAt(DateTime.now().toUtc());
        return;
      } catch (_) {
        // Fall through to queue.
      }
    }

    await local.enqueue(
      todoId: id,
      isCompleted: isCompleted,
      updatedAt: now,
    );
  }

  @override
  Future<void> syncPending() async {
    if (!await _isOnline()) return;

    final pending = await local.getPendingItems();
    if (pending.isEmpty) return;

    for (final item in pending) {
      await local.updateTodoLocal(
        id: item.todoId,
        isCompleted: item.isCompleted,
        updatedAt: item.updatedAt,
        syncStatus: 'syncing',
      );
    }

    try {
      final changes = pending
          .map(
            (p) => {
              'todo_id': p.todoId,
              'is_completed': p.isCompleted,
              'updated_at': p.updatedAt,
            },
          )
          .toList();

      await remote.syncTodos(changes);

      for (final item in pending) {
        await local.markSynced(item.todoId);
      }
      await local.clearQueue();
      await local.setLastSyncedAt(DateTime.now().toUtc());
    } catch (e) {
      for (final item in pending) {
        await local.updateTodoLocal(
          id: item.todoId,
          isCompleted: item.isCompleted,
          updatedAt: item.updatedAt,
          syncStatus: 'error',
        );
      }
      final message = e is DioException
          ? dioErrorMessage(e, fallback: 'Sync failed')
          : 'Sync failed';
      throw Exception(message);
    }
  }

  @override
  Future<int> pendingCount() => local.pendingCount();

  @override
  Future<List<PendingSyncTodo>> getPendingSyncTodos() =>
      local.getPendingSyncTodos();

  @override
  Future<bool> isOnline() => _isOnline();

  @override
  Future<DateTime?> getLastSyncedAt() => local.getLastSyncedAt();

  @override
  Stream<bool> watchOnline() async* {
    yield await _isOnline();
    await for (final _ in connectivity.onConnectivityChanged) {
      yield await _isOnline();
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
    _reconnectController.close();
  }
}
