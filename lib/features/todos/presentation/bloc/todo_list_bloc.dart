import 'dart:async';

import 'package:field_track/features/todos/domain/entities/pending_sync_todo.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';
import 'package:field_track/features/todos/domain/repositories/todo_repository.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_event.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository repository;
  StreamSubscription<void>? _reconnectSub;
  StreamSubscription<bool>? _connectivitySub;

  TodoListBloc(this.repository) : super(const TodoListState()) {
    on<TodoListStarted>(_onStarted);
    on<TodoListRefreshRequested>(_onRefresh);
    on<TodoFilterChanged>(_onFilterChanged);
    on<TodoToggled>(_onToggled);
    on<TodoSyncRequested>(_onSync);
    on<TodoConnectivityUpdated>(_onConnectivityUpdated);
  }

  Future<({
    int pendingCount,
    List<PendingSyncTodo> pendingSyncTodos,
    DateTime? lastSyncedAt,
    bool isOffline,
  })> _syncSnapshot() async {
    final pendingSyncTodos = await repository.getPendingSyncTodos();
    final lastSyncedAt = await repository.getLastSyncedAt();
    final online = await repository.isOnline();
    return (
      pendingCount: pendingSyncTodos.length,
      pendingSyncTodos: pendingSyncTodos,
      lastSyncedAt: lastSyncedAt,
      isOffline: !online,
    );
  }

  void _listenConnectivity() {
    _reconnectSub ??= repository.watchReconnect().listen((_) {
      add(const TodoSyncRequested());
    });
    _connectivitySub ??= repository.watchOnline().listen((online) {
      add(TodoConnectivityUpdated(online));
    });
  }

  void _onConnectivityUpdated(
    TodoConnectivityUpdated event,
    Emitter<TodoListState> emit,
  ) {
    emit(state.copyWith(isOffline: !event.isOnline));
  }

  Future<void> _onStarted(
    TodoListStarted event,
    Emitter<TodoListState> emit,
  ) async {
    emit(state.copyWith(status: TodoListStatus.loading, clearError: true));
    _listenConnectivity();

    try {
      final todos = await repository.fetchAndCacheTodos();
      final sync = await _syncSnapshot();
      emit(
        state.copyWith(
          status: TodoListStatus.loaded,
          todos: todos,
          pendingCount: sync.pendingCount,
          pendingSyncTodos: sync.pendingSyncTodos,
          lastSyncedAt: sync.lastSyncedAt,
          isOffline: sync.isOffline,
          syncStatus: _globalSync(sync.pendingCount, todos),
        ),
      );
      if (sync.pendingCount > 0) {
        add(const TodoSyncRequested());
      }
    } catch (e) {
      try {
        final todos = await repository.getLocalTodos();
        final sync = await _syncSnapshot();
        emit(
          state.copyWith(
            status:
                todos.isEmpty ? TodoListStatus.failure : TodoListStatus.loaded,
            todos: todos,
            pendingCount: sync.pendingCount,
            pendingSyncTodos: sync.pendingSyncTodos,
            lastSyncedAt: sync.lastSyncedAt,
            isOffline: sync.isOffline,
            syncStatus: _globalSync(sync.pendingCount, todos),
            errorMessage: todos.isEmpty ? e.toString() : null,
          ),
        );
      } catch (_) {
        emit(
          state.copyWith(
            status: TodoListStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _onRefresh(
    TodoListRefreshRequested event,
    Emitter<TodoListState> emit,
  ) async {
    try {
      final todos = await repository.fetchAndCacheTodos();
      final sync = await _syncSnapshot();
      emit(
        state.copyWith(
          status: TodoListStatus.loaded,
          todos: todos,
          pendingCount: sync.pendingCount,
          pendingSyncTodos: sync.pendingSyncTodos,
          lastSyncedAt: sync.lastSyncedAt,
          isOffline: sync.isOffline,
          syncStatus: _globalSync(sync.pendingCount, todos),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onFilterChanged(TodoFilterChanged event, Emitter<TodoListState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onToggled(
    TodoToggled event,
    Emitter<TodoListState> emit,
  ) async {
    final updated = state.todos.map((t) {
      if (t.id == event.id) {
        return t.copyWith(
          isCompleted: event.isCompleted,
          updatedAt: DateTime.now().toUtc().toIso8601String(),
          syncStatus: TodoSyncStatus.pending,
        );
      }
      return t;
    }).toList();

    emit(
      state.copyWith(
        todos: updated,
        pendingCount: state.pendingCount + 1,
        syncStatus: GlobalSyncStatus.pending,
      ),
    );

    try {
      await repository.toggleTodo(event.id, event.isCompleted);
      final todos = await repository.getLocalTodos();
      final sync = await _syncSnapshot();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: sync.pendingCount,
          pendingSyncTodos: sync.pendingSyncTodos,
          lastSyncedAt: sync.lastSyncedAt,
          isOffline: sync.isOffline,
          syncStatus: _globalSync(sync.pendingCount, todos),
        ),
      );
      if (sync.pendingCount > 0) {
        add(const TodoSyncRequested());
      }
    } catch (e) {
      final todos = await repository.getLocalTodos();
      final sync = await _syncSnapshot();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: sync.pendingCount,
          pendingSyncTodos: sync.pendingSyncTodos,
          isOffline: sync.isOffline,
          syncStatus: GlobalSyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSync(
    TodoSyncRequested event,
    Emitter<TodoListState> emit,
  ) async {
    final sync = await _syncSnapshot();
    if (sync.pendingCount == 0) {
      emit(
        state.copyWith(
          syncStatus: GlobalSyncStatus.synced,
          pendingCount: 0,
          pendingSyncTodos: const [],
          lastSyncedAt: sync.lastSyncedAt,
          isOffline: sync.isOffline,
        ),
      );
      return;
    }

    if (sync.isOffline) {
      emit(
        state.copyWith(
          pendingCount: sync.pendingCount,
          pendingSyncTodos: sync.pendingSyncTodos,
          isOffline: true,
          syncStatus: GlobalSyncStatus.pending,
        ),
      );
      return;
    }

    emit(state.copyWith(syncStatus: GlobalSyncStatus.syncing));

    try {
      await repository.syncPending();
      final todos = await repository.getLocalTodos();
      final afterSync = await _syncSnapshot();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: afterSync.pendingCount,
          pendingSyncTodos: afterSync.pendingSyncTodos,
          lastSyncedAt: afterSync.lastSyncedAt,
          isOffline: afterSync.isOffline,
          syncStatus: GlobalSyncStatus.synced,
          clearError: true,
        ),
      );
    } catch (e) {
      final todos = await repository.getLocalTodos();
      final afterSync = await _syncSnapshot();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: afterSync.pendingCount,
          pendingSyncTodos: afterSync.pendingSyncTodos,
          isOffline: afterSync.isOffline,
          syncStatus: GlobalSyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  GlobalSyncStatus _globalSync(int pending, List<Todo> todos) {
    if (pending > 0) return GlobalSyncStatus.pending;
    if (todos.any((t) => t.syncStatus == TodoSyncStatus.error)) {
      return GlobalSyncStatus.error;
    }
    if (todos.any((t) => t.syncStatus == TodoSyncStatus.syncing)) {
      return GlobalSyncStatus.syncing;
    }
    return GlobalSyncStatus.synced;
  }

  @override
  Future<void> close() {
    _reconnectSub?.cancel();
    _connectivitySub?.cancel();
    return super.close();
  }
}
