import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LocationMapPreview extends StatelessWidget {
  const LocationMapPreview({
    super.key,
    this.isEditing = false,
    this.radiusM = 150,
  });

  final bool isEditing;
  final double radiusM;

  static const _minRadiusM = 50.0;
  static const _maxRadiusM = 500.0;

  // Figma map preview (286 x 164 new / 150 edit).
  static const _figmaWidth = 286.0;
  static const _figmaVerticalLeft = 104.0;
  static const _roadThickness = 8.0;

  double _circleSize(double previewHeight) {
    const minSize = 64.0;
    final maxSize = previewHeight - 24;
    final t =
        ((radiusM - _minRadiusM) / (_maxRadiusM - _minRadiusM)).clamp(0.0, 1.0);
    return minSize + (maxSize - minSize) * t;
  }

  @override
  Widget build(BuildContext context) {
    final height = isEditing ? 150.0 : 164.0;
    final circleSize = _circleSize(height);
    final pinOffset = isEditing ? Offset.zero : const Offset(0, -7);

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final verticalLeft =
                width * (_figmaVerticalLeft / _figmaWidth);
            final roadBottom = isEditing
                ? height * (38 / 150)
                : height * (25 / 164);
            final verticalBottom = isEditing
                ? height * (1 / 150)
                : height * (15 / 164);

            return Stack(
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
                  child: Container(
                    height: _roadThickness,
                    color: AppColors.border,
                  ),
                ),
                Positioned(
                  left: verticalLeft,
                  width: _roadThickness,
                  top: 0,
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
            );
          },
        ),
      ),
    );
  }
}
