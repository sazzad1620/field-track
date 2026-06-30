import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/todos/domain/entities/todo.dart';
import 'package:flutter/material.dart';

class TodoFilterChips extends StatelessWidget {
  final TodoFilter selected;
  final ValueChanged<TodoFilter> onChanged;

  const TodoFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'All',
          selected: selected == TodoFilter.all,
          onTap: () => onChanged(TodoFilter.all),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Pending',
          selected: selected == TodoFilter.pending,
          onTap: () => onChanged(TodoFilter.pending),
        ),
        const SizedBox(width: 8),
        _Chip(
          label: 'Completed',
          selected: selected == TodoFilter.completed,
          onTap: () => onChanged(TodoFilter.completed),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
