import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FieldTrackLogo extends StatelessWidget {
  const FieldTrackLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.location_on_outlined,
            color: AppColors.surface,
            size: 30,
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.44,
            ),
            children: [
              TextSpan(text: 'Field'),
              TextSpan(
                text: 'Track',
                style: TextStyle(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
