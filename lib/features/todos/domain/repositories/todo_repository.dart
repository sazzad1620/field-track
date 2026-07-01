import 'package:field_track/features/todos/domain/entities/pending_sync_todo.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> fetchAndCacheTodos();

  Future<List<Todo>> getLocalTodos();

  Future<void> toggleTodo(String id, bool isCompleted);

  Future<void> syncPending();

  Future<int> pendingCount();

  Future<List<PendingSyncTodo>> getPendingSyncTodos();

  Future<bool> isOnline();

  Future<DateTime?> getLastSyncedAt();

  Stream<bool> watchOnline();

  Stream<void> watchReconnect();
}
