import 'package:drift/drift.dart';
import 'package:field_track/features/todos/data/database/app_database.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String? dueAt;
  final String createdAt;
  final String updatedAt;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.dueAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['is_completed'] as bool,
      dueAt: json['due_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  TodoItemsCompanion toCompanion({String? syncStatus}) {
    return TodoItemsCompanion.insert(
      id: id,
      title: title,
      description: Value(description),
      isCompleted: isCompleted,
      dueAt: Value(dueAt),
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: Value(syncStatus ?? 'synced'),
    );
  }

  Todo toEntity({TodoSyncStatus syncStatus = TodoSyncStatus.synced}) {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueAt: dueAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  static Todo fromRow(TodoItem row) {
    return Todo(
      id: row.id,
      title: row.title,
      description: row.description,
      isCompleted: row.isCompleted,
      dueAt: row.dueAt,
      updatedAt: row.updatedAt,
      syncStatus: _parseSyncStatus(row.syncStatus),
    );
  }

  static TodoSyncStatus _parseSyncStatus(String value) {
    return TodoSyncStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => TodoSyncStatus.synced,
    );
  }
}
