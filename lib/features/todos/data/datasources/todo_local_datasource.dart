import 'package:drift/drift.dart';
import 'package:field_track/features/todos/data/database/app_database.dart';
import 'package:field_track/features/todos/data/models/todo_model.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';

class TodoLocalDatasource {
  final AppDatabase db;

  TodoLocalDatasource(this.db);

  Future<void> upsertTodos(List<TodoModel> todos) async {
    await db.batch((batch) {
      for (final todo in todos) {
        batch.insert(
          db.todoItems,
          todo.toCompanion(),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<Todo>> getTodos() async {
    final rows = await db.select(db.todoItems).get();
    return rows.map(TodoModel.fromRow).toList();
  }

  Future<void> updateTodoLocal({
    required String id,
    required bool isCompleted,
    required String updatedAt,
    required String syncStatus,
  }) async {
    await (db.update(db.todoItems)..where((t) => t.id.equals(id))).write(
      TodoItemsCompanion(
        isCompleted: Value(isCompleted),
        updatedAt: Value(updatedAt),
        syncStatus: Value(syncStatus),
      ),
    );
  }

  Future<void> markSynced(String id) async {
    await (db.update(db.todoItems)..where((t) => t.id.equals(id))).write(
      const TodoItemsCompanion(syncStatus: Value('synced')),
    );
  }

  Future<void> enqueue({
    required String todoId,
    required bool isCompleted,
    required String updatedAt,
  }) async {
    final existing = await (db.select(db.pendingSyncItems)
          ..where((p) => p.todoId.equals(todoId)))
        .getSingleOrNull();

    if (existing != null) {
      await (db.update(db.pendingSyncItems)
            ..where((p) => p.id.equals(existing.id)))
          .write(
        PendingSyncItemsCompanion(
          isCompleted: Value(isCompleted),
          updatedAt: Value(updatedAt),
        ),
      );
    } else {
      await db.into(db.pendingSyncItems).insert(
            PendingSyncItemsCompanion.insert(
              todoId: todoId,
              isCompleted: isCompleted,
              updatedAt: updatedAt,
            ),
          );
    }
  }

  Future<void> removeFromQueue(String todoId) async {
    await (db.delete(db.pendingSyncItems)
          ..where((p) => p.todoId.equals(todoId)))
        .go();
  }

  Future<List<PendingSyncItem>> getPendingItems() async {
    return db.select(db.pendingSyncItems).get();
  }

  Future<int> pendingCount() async {
    final count = db.pendingSyncItems.id.count();
    final query = db.selectOnly(db.pendingSyncItems)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> clearQueue() async {
    await db.delete(db.pendingSyncItems).go();
  }
}
