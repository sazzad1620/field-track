import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_bloc.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_event.dart';
import 'package:field_track/features/todos/presentation/bloc/todo_list_state.dart';
import 'package:field_track/features/todos/presentation/widgets/sync_offline_banner.dart';
import 'package:field_track/features/todos/presentation/widgets/sync_pending_todo_card.dart';
import 'package:field_track/features/todos/presentation/widgets/sync_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  /// Figma sync content inset: `padding: 4px 20px 92px`.
  static const _horizontalPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoListBloc, TodoListState>(
      listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage &&
          curr.errorMessage != null &&
          curr.pendingCount > 0,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(_friendlySyncError(message)),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      child: BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          final isSyncing = state.syncStatus == GlobalSyncStatus.syncing;
          final hasPending = state.pendingCount > 0;

          return CustomScrollView(
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
                  child: const Text(
                    'Sync',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      height: 25 / 21,
                      letterSpacing: -0.42,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding,
                  4,
                  _horizontalPadding,
                  92,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (hasPending && state.isOffline) ...[
                      const SyncOfflineBanner(),
                      const SizedBox(height: 10),
                    ],
                    if (hasPending) ...[
                      SyncSummaryCard(
                        pendingCount: state.pendingCount,
                        lastSyncedAt: state.lastSyncedAt,
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(top: 6, bottom: 10),
                        child: Text(
                          'WAITING TO UPLOAD',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            height: 15 / 12,
                            letterSpacing: 0.6,
                            color: AppColors.placeholder,
                          ),
                        ),
                      ),
                      for (var i = 0; i < state.pendingSyncTodos.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        SyncPendingTodoCard(
                          item: state.pendingSyncTodos[i],
                          icon: syncPendingIcons[i % syncPendingIcons.length],
                        ),
                      ],
                      const SizedBox(height: 10),
                    ] else ...[
                      SyncSummaryCard(
                        pendingCount: 0,
                        lastSyncedAt: state.lastSyncedAt,
                      ),
                      const SizedBox(height: 10),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: isSyncing || !hasPending
                            ? null
                            : () => context
                                    .read<TodoListBloc>()
                                    .add(const TodoSyncRequested()),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.primary.withValues(alpha: 0.45),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        icon: isSyncing
                            ? const SizedBox(
                                width: 19,
                                height: 19,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.sync_rounded, size: 19),
                        label: Text(
                          isSyncing ? 'Syncing...' : 'Sync now',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                            height: 19 / 15.5,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _friendlySyncError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('unauthorized')) {
      return 'Sync failed. Please sign in again.';
    }
    if (lower.contains('socket') || lower.contains('network')) {
      return 'Sync failed. Check your connection and try again.';
    }
    return 'Sync failed. Tap Sync now to retry.';
  }
}
