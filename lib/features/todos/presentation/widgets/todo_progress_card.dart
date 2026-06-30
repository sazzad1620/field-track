import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:flutter/material.dart';

class TodoProgressCard extends StatelessWidget {
  final int completed;
  final int total;

  const TodoProgressCard({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: AppDecorations.card(background: AppColors.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "Today's progress",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  height: 16 / 13.5,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$completed of $total done',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  height: 16 / 13,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ProgressBar(progress: progress.clamp(0.0, 1.0)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fillWidth = constraints.maxWidth * progress;

        return SizedBox(
          height: 8,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.progressTrack,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const SizedBox(width: double.infinity, height: 8),
              ),
              if (fillWidth > 0)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: fillWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
