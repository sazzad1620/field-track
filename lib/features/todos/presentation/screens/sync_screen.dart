import 'package:field_track/core/constants/shell_layout.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_bloc.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_event.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        final (icon, color, title, subtitle) = _syncInfo(state);

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            ShellLayout.contentHorizontalPadding,
            8,
            ShellLayout.contentHorizontalPadding,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sync',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F141C28),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                    BoxShadow(
                      color: Color(0x0D141C28),
                      offset: Offset(0, 6),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(icon, size: 48, color: color),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (state.pendingCount > 0) ...[
                      const SizedBox(height: 16),
                      Text(
                        '${state.pendingCount} change(s) waiting to sync',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pendingBadgeText,
                        ),
                      ),
                    ],
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state.syncStatus == GlobalSyncStatus.syncing
                            ? null
                            : () => context
                                .read<TodoListBloc>()
                                .add(const TodoSyncRequested()),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          state.syncStatus == GlobalSyncStatus.syncing
                              ? 'Syncing...'
                              : 'Sync now',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  (IconData, Color, String, String) _syncInfo(TodoListState state) {
    switch (state.syncStatus) {
      case GlobalSyncStatus.syncing:
        return (
          Icons.sync,
          AppColors.primary,
          'Syncing',
          'Uploading your offline changes...',
        );
      case GlobalSyncStatus.pending:
        return (
          Icons.cloud_upload_outlined,
          AppColors.pendingBadgeText,
          'Pending sync',
          'Changes are saved locally and will sync when online.',
        );
      case GlobalSyncStatus.error:
        return (
          Icons.error_outline,
          AppColors.error,
          'Sync failed',
          'Tap sync now to retry.',
        );
      case GlobalSyncStatus.synced:
        return (
          Icons.cloud_done_outlined,
          AppColors.success,
          'All synced',
          'Your tasks are up to date with the server.',
        );
    }
  }
}
