import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/core/theme/app_decorations.dart';
import 'package:flutter/material.dart';

class LocationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const LocationSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  static const _fieldDecoration = InputDecoration(
    hintText: 'Search locations',
    hintStyle: TextStyle(
      fontSize: 14.5,
      height: 18 / 14.5,
      color: AppColors.placeholder,
    ),
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    filled: false,
    isDense: true,
    contentPadding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardShadowShell(radius: 13),
      child: Material(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: AppDecorations.cardShape(radius: 13),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 46,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 18,
                  color: AppColors.placeholder,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 18 / 14.5,
                      color: AppColors.textPrimary,
                    ),
                    decoration: _fieldDecoration,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
