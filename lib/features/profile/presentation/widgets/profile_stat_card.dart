import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_card_shell.dart';
import 'package:flutter/material.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  static const _cardHeight = 77.0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ProfileCardShell(
        radius: 16,
        child: SizedBox(
          height: _cardHeight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 23,
                    height: 28 / 23,
                    letterSpacing: -0.46,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 15 / 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
