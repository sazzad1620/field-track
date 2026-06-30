import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LocationMapPreview extends StatelessWidget {
  final bool isEditing;

  const LocationMapPreview({
    super.key,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = isEditing ? 150.0 : 164.0;
    final circleSize = isEditing ? 108.0 : 96.0;
    final pinOffset = isEditing ? Offset.zero : const Offset(0, -7);
    final roadBottom = isEditing ? height * 0.3678 : 42.0;
    final verticalBottom = isEditing ? 1.0 : 15.0;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.completedCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.border.withValues(alpha: 1),
            AppColors.border.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.12],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.border.withValues(alpha: 0.85),
                    AppColors.border.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.1],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: roadBottom,
              child: Container(height: 8, color: AppColors.border),
            ),
            Positioned(
              left: 109,
              width: 12,
              top: 1,
              bottom: verticalBottom,
              child: Container(color: AppColors.border),
            ),
            Center(
              child: Transform.translate(
                offset: pinOffset,
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: AppColors.focusRing.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: pinOffset,
                child: Icon(
                  Icons.location_on,
                  size: 34,
                  color: AppColors.primary,
                  shadows: const [
                    Shadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
