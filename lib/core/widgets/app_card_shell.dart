import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:flutter/material.dart';

/// Shadow container wrapping Material — matches [LocationCard] / Figma cards.
class AppCardShell extends StatelessWidget {
  const AppCardShell({
    super.key,
    required this.child,
    this.radius = 16,
    this.padding,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardShadowShell(radius: radius),
      child: Material(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: AppDecorations.cardShape(radius: radius),
        clipBehavior: Clip.antiAlias,
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
