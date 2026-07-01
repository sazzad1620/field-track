import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:field_track/features/todos/core/todo_date_format.dart';
import 'package:flutter/material.dart';

class SyncSummaryCard extends StatelessWidget {
  const SyncSummaryCard({
    super.key,
    required this.pendingCount,
    required this.lastSyncedAt,
  });

  final int pendingCount;
  final DateTime? lastSyncedAt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: AppDecorations.cardShadowShell(radius: 16),
        ),
        Material(
          color: AppColors.surface,
          shape: AppDecorations.cardShape(radius: 16),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.focusRing,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.sync_rounded,
                    size: 24,
                    color: AppColors.pinActive,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pendingChangesLabel(pendingCount),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          height: 21 / 17,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatLastSynced(lastSyncedAt),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.5,
                          height: 15 / 12.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
