import 'dart:async';

import 'package:field_track/features/todos/domain/entities/todo.dart';
import 'package:field_track/features/todos/domain/repositories/todo_repository.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_event.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository repository;
  StreamSubscription<void>? _reconnectSub;

  TodoListBloc(this.repository) : super(const TodoListState()) {
    on<TodoListStarted>(_onStarted);
    on<TodoListRefreshRequested>(_onRefresh);
    on<TodoFilterChanged>(_onFilterChanged);
    on<TodoToggled>(_onToggled);
    on<TodoSyncRequested>(_onSync);
  }

  Future<void> _onStarted(
    TodoListStarted event,
    Emitter<TodoListState> emit,
  ) async {
    emit(state.copyWith(status: TodoListStatus.loading, clearError: true));
    _reconnectSub ??= repository.watchReconnect().listen((_) {
      add(const TodoSyncRequested());
    });

    try {
      final todos = await repository.fetchAndCacheTodos();
      final pending = await repository.pendingCount();
      emit(
        state.copyWith(
          status: TodoListStatus.loaded,
          todos: todos,
          pendingCount: pending,
          syncStatus: _globalSync(pending, todos),
        ),
      );
      if (pending > 0) {
        add(const TodoSyncRequested());
      }
    } catch (e) {
      try {
        final todos = await repository.getLocalTodos();
        final pending = await repository.pendingCount();
        emit(
          state.copyWith(
            status: todos.isEmpty ? TodoListStatus.failure : TodoListStatus.loaded,
            todos: todos,
            pendingCount: pending,
            syncStatus: _globalSync(pending, todos),
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
      final pending = await repository.pendingCount();
      emit(
        state.copyWith(
          status: TodoListStatus.loaded,
          todos: todos,
          pendingCount: pending,
          syncStatus: _globalSync(pending, todos),
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

  Future<void> _onToggled(TodoToggled event, Emitter<TodoListState> emit) async {
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

    final pending = state.pendingCount + 1;
    emit(
      state.copyWith(
        todos: updated,
        pendingCount: pending,
        syncStatus: GlobalSyncStatus.pending,
      ),
    );

    try {
      await repository.toggleTodo(event.id, event.isCompleted);
      final todos = await repository.getLocalTodos();
      final count = await repository.pendingCount();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: count,
          syncStatus: _globalSync(count, todos),
        ),
      );
      if (count > 0) {
        add(const TodoSyncRequested());
      }
    } catch (e) {
      final todos = await repository.getLocalTodos();
      final count = await repository.pendingCount();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: count,
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
    final pending = await repository.pendingCount();
    if (pending == 0) {
      emit(state.copyWith(syncStatus: GlobalSyncStatus.synced, pendingCount: 0));
      return;
    }

    emit(state.copyWith(syncStatus: GlobalSyncStatus.syncing));

    try {
      await repository.syncPending();
      final todos = await repository.getLocalTodos();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: 0,
          syncStatus: GlobalSyncStatus.synced,
          clearError: true,
        ),
      );
    } catch (e) {
      final todos = await repository.getLocalTodos();
      final count = await repository.pendingCount();
      emit(
        state.copyWith(
          todos: todos,
          pendingCount: count,
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
    return super.close();
  }
}
