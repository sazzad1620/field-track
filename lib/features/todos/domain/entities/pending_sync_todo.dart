import 'package:equatable/equatable.dart';

class PendingSyncTodo extends Equatable {
  final String todoId;
  final String title;
  final bool isCompleted;
  final String updatedAt;

  const PendingSyncTodo({
    required this.todoId,
    required this.title,
    required this.isCompleted,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [todoId, title, isCompleted, updatedAt];
}
