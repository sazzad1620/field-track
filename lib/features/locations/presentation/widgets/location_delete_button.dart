import 'package:flutter/material.dart';

/// Figma delete action color `#DC4040`.
const _deleteColor = Color(0xFFDC4040);

class LocationDeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LocationDeleteButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _deleteColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_outline,
                size: 19,
                color: onPressed == null ? _deleteColor.withValues(alpha: 0.4) : _deleteColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Delete location',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  height: 19 / 15.5,
                  color: onPressed == null
                      ? _deleteColor.withValues(alpha: 0.4)
                      : _deleteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
