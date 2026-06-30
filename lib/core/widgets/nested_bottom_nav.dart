import 'package:field_track/core/constants/shell_layout.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NestedBottomNavItem {
  final String label;
  final IconData icon;

  const NestedBottomNavItem({required this.label, required this.icon});
}

class NestedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NestedBottomNavItem> items;

  const NestedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            ShellLayout.navHorizontalInset,
            0,
            ShellLayout.navHorizontalInset,
            ShellLayout.navBottomInset,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(
                top: BorderSide(color: AppColors.border),
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(ShellLayout.navBottomRadius),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A141C28),
                  offset: Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SizedBox(
              height: ShellLayout.navBarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShellLayout.navInnerHorizontalPadding,
                ),
                child: Row(
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final active = currentIndex == i;
                    final color =
                        active ? AppColors.primary : AppColors.navInactive;
                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onTap(i),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 23, color: color),
                              const SizedBox(height: 4),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  height: 13 / 10.5,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
