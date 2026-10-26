import 'package:flutter/material.dart';

/// A reusable circular back button designed for dark mode UIs across the app.
///
/// Automatically pops the current screen off the navigation stack unless a custom
/// [onPressed] callback is provided.
class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color iconColor;
  final Color borderColor;
  final Color backgroundColor;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.iconColor = Colors.white,
    this.borderColor = Colors.white24,
    this.backgroundColor = Colors.black26,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor, size: 20),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        onPressed: onPressed ?? () => Navigator.pop(context),
      ),
    );
  }
}
