import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SyncOfflineBanner extends StatelessWidget {
  const SyncOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.pendingBadgeBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 21,
            color: AppColors.pendingBadgeText,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "You're offline",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    height: 16 / 13.5,
                    color: AppColors.pendingBadgeText,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Changes are saved on this device',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.5,
                    height: 15 / 12.5,
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
