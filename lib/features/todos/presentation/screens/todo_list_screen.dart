import 'package:field_track/core/constants/shell_layout.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/widgets/empty_view.dart';
import 'package:field_track/core/widgets/error_view.dart';
import 'package:field_track/core/widgets/loading_view.dart';
import 'package:field_track/features/todos/core/todo_date_format.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_bloc.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_event.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_state.dart';
import 'package:field_track/features/todos/presentation/widgets/todo_card.dart';
import 'package:field_track/features/todos/presentation/widgets/todo_filter_chips.dart';
import 'package:field_track/features/todos/presentation/widgets/todo_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  static const _horizontalPadding = ShellLayout.contentHorizontalPadding;
  static const _listBottomPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        if (state.status == TodoListStatus.loading && state.todos.isEmpty) {
          return const LoadingView();
        }

        if (state.status == TodoListStatus.failure && state.todos.isEmpty) {
          return ErrorView(
            message: state.errorMessage ?? 'Could not load tasks',
            onRetry: () =>
                context.read<TodoListBloc>().add(const TodoListStarted()),
          );
        }

        final todos = state.filteredTodos;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final bloc = context.read<TodoListBloc>();
            final done = bloc.stream.firstWhere(
              (s) => s.status != TodoListStatus.loading,
            );
            bloc.add(const TodoListRefreshRequested());
            await done;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _horizontalPadding,
                    8,
                    _horizontalPadding,
                    14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My tasks',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                          height: 25 / 21,
                          letterSpacing: -0.42,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatHeaderDate(DateTime.now()),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          height: 16 / 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding,
                  4,
                  _horizontalPadding,
                  0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TodoProgressCard(
                      completed: state.completedCount,
                      total: state.totalCount,
                    ),
                    const SizedBox(height: 11),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TodoFilterChips(
                        selected: state.filter,
                        onChanged: (filter) => context
                            .read<TodoListBloc>()
                            .add(TodoFilterChanged(filter)),
                      ),
                    ),
                  ]),
                ),
              ),
              if (todos.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyView(message: 'No tasks in this filter'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    _horizontalPadding,
                    11,
                    _horizontalPadding,
                    _listBottomPadding,
                  ),
                  sliver: SliverList.separated(
                    itemCount: todos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 11),
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoCard(
                        todo: todo,
                        onToggle: (value) => context.read<TodoListBloc>().add(
                              TodoToggled(id: todo.id, isCompleted: value),
                            ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
