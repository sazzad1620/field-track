import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Figma sign-out color `#DC4040`.
const profileSignOutColor = Color(0xFFDC4040);

class ProfileSignOutButton extends StatelessWidget {
  const ProfileSignOutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: profileSignOutColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: const SizedBox(
          width: double.infinity,
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 19, color: profileSignOutColor),
              SizedBox(width: 8),
              Text(
                'Sign out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.5,
                  height: 19 / 15.5,
                  color: profileSignOutColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
