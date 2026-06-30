import 'package:equatable/equatable.dart';

enum TodoSyncStatus { synced, pending, syncing, error }

enum TodoFilter { all, pending, completed }

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String? dueAt;
  final String updatedAt;
  final TodoSyncStatus syncStatus;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.updatedAt,
    this.dueAt,
    this.syncStatus = TodoSyncStatus.synced,
  });

  Todo copyWith({
    bool? isCompleted,
    String? updatedAt,
    TodoSyncStatus? syncStatus,
  }) {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueAt: dueAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        dueAt,
        updatedAt,
        syncStatus,
      ];
}
