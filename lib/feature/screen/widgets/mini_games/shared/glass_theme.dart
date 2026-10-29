import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_colors.dart';

/// Theme-aware glassmorphism colors shared by all mini games.
class GlassTheme {
  GlassTheme._();

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color textPrimary(BuildContext context) => isDark(context)
      ? AppColors.darkTextPrimary
      : AppColors.lightTextPrimary;

  static Color textSecondary(BuildContext context) => isDark(context)
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary;

  static Color glassFill(BuildContext context) => isDark(context)
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.white.withValues(alpha: 0.55);

  static Color glassBorder(BuildContext context) => isDark(context)
      ? Colors.white.withValues(alpha: 0.14)
      : Colors.black.withValues(alpha: 0.06);

  static Color cellFill(BuildContext context) => isDark(context)
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.white.withValues(alpha: 0.45);
}
