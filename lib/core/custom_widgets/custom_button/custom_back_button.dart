import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.color = AppColors.lightTextPrimary,
    this.onPressed,
  });

  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back_ios, size: 20, color: color),
    );
  }
}
