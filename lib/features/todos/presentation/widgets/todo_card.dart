import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:field_track/features/todos/core/todo_date_format.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool> onToggle;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final completed = todo.isCompleted;
    final timeLabel = formatTodoTime(
      completed ? todo.updatedAt : todo.dueAt,
      isCompleted: completed,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        15,
        completed ? 17 : 14,
        15,
        completed ? 14 : 14,
      ),
      decoration: AppDecorations.card(
        background: completed ? AppColors.completedCard : AppColors.surface,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: _Checkbox(
              completed: completed,
              onTap: () => onToggle(!completed),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 18 / 15,
                    decoration: completed ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.completedText,
                    color: completed ? AppColors.completedText : AppColors.textPrimary,
                  ),
                ),
                if (todo.description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    todo.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 18 / 13,
                      color: completed ? AppColors.completedText : AppColors.textMuted,
                    ),
                  ),
                ],
                if (timeLabel.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(top: completed ? 7 : 7),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_outlined,
                          size: 13,
                          color: AppColors.completedText,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          timeLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 15 / 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const Spacer(),
                        _StatusBadge(completed: completed),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 7),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _StatusBadge(completed: completed),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool completed;
  final VoidCallback onTap;

  const _Checkbox({required this.completed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: completed ? AppColors.success : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: completed ? AppColors.success : AppColors.border,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: completed
            ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
            : null,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool completed;

  const _StatusBadge({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: completed ? AppColors.successBg : AppColors.pendingBadgeBg,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        completed ? 'Completed' : 'Pending',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 13 / 11,
          color: completed ? AppColors.success : AppColors.pendingBadgeText,
        ),
      ),
    );
  }
}
