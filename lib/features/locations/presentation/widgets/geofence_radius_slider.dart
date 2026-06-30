import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:flutter/material.dart';

class GeofenceRadiusSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const GeofenceRadiusSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'Geofence radius',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 15 / 12.5,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              '${value.round()} m',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 18 / 15,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            trackShape: const RoundedRectSliderTrackShape(),
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.progressTrack,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const _GeofenceThumbShape(),
          ),
          child: Slider(
            min: 50,
            max: 500,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _GeofenceThumbShape extends SliderComponentShape {
  const _GeofenceThumbShape();

  static const double _thumbSize = 20;
  static const double _borderWidth = 3;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(_thumbSize, _thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: _thumbSize,
        height: _thumbSize,
      ),
      const Radius.circular(10),
    );

    for (final shadow in AppDecorations.cardShadow) {
      canvas.drawRRect(
        rect.shift(shadow.offset),
        Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius / 2),
      );
    }

    canvas.drawRRect(rect, Paint()..color = AppColors.primary);
    canvas.drawRRect(
      rect.deflate(_borderWidth / 2),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth,
    );
  }
}
