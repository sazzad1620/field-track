import 'package:field_track/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LocationFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hint;

  const LocationFormField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.hint,
  });

  static const _fieldDecoration = InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    filled: false,
    contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 16),
  );

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
        const SizedBox(height: 7),
        Material(
          color: AppColors.surface,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 50,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.2,
                color: AppColors.textPrimary,
              ),
              decoration: _fieldDecoration.copyWith(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  height: 1.2,
                  color: AppColors.placeholder,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
