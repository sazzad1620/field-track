import 'package:equatable/equatable.dart';
import 'package:field_track/features/todos/domain/entities/pending_sync_todo.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';

enum TodoListStatus { initial, loading, loaded, failure }

enum GlobalSyncStatus { synced, pending, syncing, error }

class TodoListState extends Equatable {
  final TodoListStatus status;
  final List<Todo> todos;
  final TodoFilter filter;
  final GlobalSyncStatus syncStatus;
  final int pendingCount;
  final List<PendingSyncTodo> pendingSyncTodos;
  final bool isOffline;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  const TodoListState({
    this.status = TodoListStatus.initial,
    this.todos = const [],
    this.filter = TodoFilter.all,
    this.syncStatus = GlobalSyncStatus.synced,
    this.pendingCount = 0,
    this.pendingSyncTodos = const [],
    this.isOffline = false,
    this.lastSyncedAt,
    this.errorMessage,
  });

  List<Todo> get filteredTodos {
    Iterable<Todo> list;
    switch (filter) {
      case TodoFilter.pending:
        list = todos.where((t) => !t.isCompleted);
      case TodoFilter.completed:
        list = todos.where((t) => t.isCompleted);
      case TodoFilter.all:
        list = todos;
    }
    final result = List<Todo>.from(list);
    if (filter == TodoFilter.all) {
      result.sort((a, b) {
        if (a.isCompleted == b.isCompleted) return 0;
        return a.isCompleted ? -1 : 1;
      });
    }
    return result;
  }

  int get completedCount => todos.where((t) => t.isCompleted).length;

  int get totalCount => todos.length;

  TodoListState copyWith({
    TodoListStatus? status,
    List<Todo>? todos,
    TodoFilter? filter,
    GlobalSyncStatus? syncStatus,
    int? pendingCount,
    List<PendingSyncTodo>? pendingSyncTodos,
    bool? isOffline,
    DateTime? lastSyncedAt,
    bool clearLastSyncedAt = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TodoListState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      syncStatus: syncStatus ?? this.syncStatus,
      pendingCount: pendingCount ?? this.pendingCount,
      pendingSyncTodos: pendingSyncTodos ?? this.pendingSyncTodos,
      isOffline: isOffline ?? this.isOffline,
      lastSyncedAt:
          clearLastSyncedAt ? null : (lastSyncedAt ?? this.lastSyncedAt),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        syncStatus,
        pendingCount,
        pendingSyncTodos,
        isOffline,
        lastSyncedAt,
        errorMessage,
      ];
}
