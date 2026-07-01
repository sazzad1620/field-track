import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:field_track/features/profile/presentation/widgets/profile_subpage_scaffold.dart';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSubpageScaffold(
      title: 'Help & support',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _HelpCard(
            title: 'Tasks & offline sync',
            body:
                'Mark tasks done from My tasks. Changes save locally when offline and upload from the Sync tab when you reconnect.',
          ),
          SizedBox(height: 12),
          _HelpCard(
            title: 'Locations & geofence',
            body:
                'Add active locations with a radius. You receive a notification when you enter the area. Allow background location for best results on Android.',
          ),
          SizedBox(height: 12),
          _HelpCard(
            title: 'Need more help?',
            body:
                'Contact your field operations admin or email support@fieldtrack.com for account issues.',
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.title, required this.body});

  final String title;
  final String body;

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 18 / 13.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
