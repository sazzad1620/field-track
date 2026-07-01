import 'package:equatable/equatable.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';

abstract class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object?> get props => [];
}

class TodoListStarted extends TodoListEvent {
  const TodoListStarted();
}

class TodoListRefreshRequested extends TodoListEvent {
  const TodoListRefreshRequested();
}

class TodoFilterChanged extends TodoListEvent {
  final TodoFilter filter;

  const TodoFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class TodoToggled extends TodoListEvent {
  final String id;
  final bool isCompleted;

  const TodoToggled({required this.id, required this.isCompleted});

  @override
  List<Object?> get props => [id, isCompleted];
}

class TodoSyncRequested extends TodoListEvent {
  const TodoSyncRequested();
}

class TodoConnectivityUpdated extends TodoListEvent {
  final bool isOnline;

  const TodoConnectivityUpdated(this.isOnline);

  @override
  List<Object?> get props => [isOnline];
}
