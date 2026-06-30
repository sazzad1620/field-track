import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppDecorations {
  static const cardShadow = [
    BoxShadow(
      color: Color(0x0F141C28),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Color(0x0D141C28),
      offset: Offset(0, 6),
      blurRadius: 16,
    ),
  ];

  static BoxDecoration card({required Color background}) {
    return BoxDecoration(
      color: background,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(16),
      boxShadow: cardShadow,
    );
  }
}
