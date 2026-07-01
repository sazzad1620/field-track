import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/profile/core/profile_helpers.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_card_shell.dart';
import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role;

  @override
  Widget build(BuildContext context) {
    return ProfileCardShell(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: AppColors.focusRing,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              userInitials(name),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 27,
                height: 33 / 27,
                color: AppColors.pinActive,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 19,
              height: 23 / 19,
              color: AppColors.textPrimary,
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.5,
                height: 16 / 13.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.focusRing,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 13,
                  color: AppColors.pinActive,
                ),
                const SizedBox(width: 6),
                Text(
                  formatRoleLabel(role),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 15 / 12,
                    color: AppColors.pinActive,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
