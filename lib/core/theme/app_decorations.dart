import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppDecorations {
  /// Figma: `0px 1px 2px rgba(20, 28, 40, 0.06), 0px 6px 16px rgba(20, 28, 40, 0.05)`
  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: Color.fromRGBO(20, 28, 40, 0.06),
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color.fromRGBO(20, 28, 40, 0.05),
          offset: Offset(0, 6),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get fabShadow => const [
        BoxShadow(
          color: Color.fromRGBO(13, 148, 136, 0.4),
          offset: Offset(0, 6),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ];

  /// Shadow-only outer shell — paint beneath border + fill for a soft blend.
  static BoxDecoration cardShadowShell({double radius = 16}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: cardShadow,
    );
  }

  /// Border + fill without shadow (pairs with [cardShadowShell]).
  static ShapeBorder cardShape({double radius = 16}) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: const BorderSide(color: AppColors.border, width: 1),
    );
  }

  static BoxDecoration card({required Color background, double radius = 16}) {
    return BoxDecoration(
      color: background,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: cardShadow,
    );
  }

  static BoxDecoration searchBar() {
    return BoxDecoration(
      color: AppColors.surface,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(13),
      boxShadow: cardShadow,
    );
  }
}
