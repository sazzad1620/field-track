import 'package:field_track/core/constants/shell_layout.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LocationsPlaceholderScreen extends StatelessWidget {
  const LocationsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShellLayout.contentHorizontalPadding,
        8,
        ShellLayout.contentHorizontalPadding,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Locations',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 48,
                    color: AppColors.navInactive,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Coming in Phase 3',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
