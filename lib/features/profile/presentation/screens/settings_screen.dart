import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_subpage_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubpageScaffold(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SettingsCard(
            children: const [
              _InfoRow(label: 'App', value: 'Field Track'),
              Divider(height: 1, color: AppColors.border),
              _InfoRow(label: 'Version', value: '1.0.0'),
              Divider(height: 1, color: AppColors.border),
              _InfoRow(label: 'Environment', value: 'Production API'),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Field Track stores tasks and locations locally for offline use. Sign out clears your session but keeps cached data on this device.',
            style: TextStyle(
              fontSize: 12.5,
              height: 16 / 12.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(decoration: AppDecorations.cardShadowShell(radius: 16)),
        Material(
          color: AppColors.surface,
          shape: AppDecorations.cardShape(radius: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}
