import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:field_track/features/todos/core/todo_date_format.dart';
import 'package:field_track/features/todos/domain/entities/pending_sync_todo.dart';
import 'package:flutter/material.dart';

class SyncPendingTodoCard extends StatelessWidget {
  const SyncPendingTodoCard({
    super.key,
    required this.item,
    required this.icon,
  });

  final PendingSyncTodo item;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: AppDecorations.cardShadowShell(radius: 14),
        ),
        Material(
          color: AppColors.surface,
          shape: AppDecorations.cardShape(radius: 14),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.completedCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 17 / 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatMarkedDoneTime(item.updatedAt),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 15 / 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.pendingBadgeBg,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Text(
                          'Pending',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            height: 13 / 11,
                            color: AppColors.pendingBadgeText,
                          ),
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

const syncPendingIcons = [
  Icons.inventory_2_outlined,
  Icons.description_outlined,
  Icons.location_on_outlined,
];
