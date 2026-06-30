import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = location.isActive;
    final cardPadding = active
        ? const EdgeInsets.fromLTRB(16, 19, 16, 15)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 15);

    final card = Container(
      decoration: AppDecorations.cardShadowShell(),
      child: Material(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: AppDecorations.cardShape(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: cardPadding,
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: active ? AppColors.focusRing : AppColors.completedCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 21,
                  color: active ? AppColors.pinActive : AppColors.placeholder,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.locationName,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        height: 19 / 15.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.my_location_outlined,
                          size: 13,
                          color: AppColors.placeholder,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 15 / 12.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          _Badge(
                            label: '${location.radiusM} m radius',
                            background: AppColors.completedCard,
                            foreground: AppColors.textMuted,
                          ),
                          const SizedBox(width: 7),
                          _Badge(
                            label: active ? 'Active' : 'Inactive',
                            background: active
                                ? AppColors.successBg
                                : AppColors.completedCard,
                            foreground:
                                active ? AppColors.success : AppColors.placeholder,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.placeholder,
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );

    if (active) return card;

    return Opacity(
      opacity: 0.62,
      child: card,
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          height: 14 / 11.5,
          color: foreground,
        ),
      ),
    );
  }
}
