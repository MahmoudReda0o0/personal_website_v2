import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_theme.dart';

/// Tic Tac Toe colors. Glass helpers delegate to the shared [GlassTheme].
class TttTheme {
  TttTheme._();

  static const Color xColor = Color(0xFF00C2FF);
  static const Color oColor = Color(0xFFFF5FA2);
  static const Color drawColor = Color(0xFFB0B0B0);

  static bool isDark(BuildContext context) => GlassTheme.isDark(context);

  static Color textPrimary(BuildContext context) =>
      GlassTheme.textPrimary(context);

  static Color textSecondary(BuildContext context) =>
      GlassTheme.textSecondary(context);

  static Color glassFill(BuildContext context) => GlassTheme.glassFill(context);

  static Color glassBorder(BuildContext context) =>
      GlassTheme.glassBorder(context);

  static Color cellFill(BuildContext context) => GlassTheme.cellFill(context);
}
