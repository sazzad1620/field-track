import 'package:field_track/features/todos/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> fetchAndCacheTodos();

  Future<List<Todo>> getLocalTodos();

  Future<void> toggleTodo(String id, bool isCompleted);

  Future<void> syncPending();

  Future<int> pendingCount();

  Stream<void> watchReconnect();
}
