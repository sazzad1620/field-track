import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/auth/domain/entities/user.dart';
import 'package:field_track/features/profile/core/profile_helpers.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_card_shell.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_subpage_scaffold.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'User';
    final email = user?.email ?? '';
    final role = user?.role ?? '';

    return ProfileSubpageScaffold(
      title: 'Edit profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoCard(
            child: Column(
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
                      color: AppColors.pinActive,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  formatRoleLabel(role),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.pinActive,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ReadOnlyField(label: 'Full name', value: name),
                const SizedBox(height: 14),
                _ReadOnlyField(label: 'Email', value: email),
                const SizedBox(height: 14),
                const Text(
                  'Profile details come from your account. Contact your admin to change them.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 16 / 12.5,
                    color: AppColors.textMuted,
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

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            height: 15 / 12.5,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.completedCard,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              height: 18 / 14.5,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProfileCardShell(
      radius: 16,
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
