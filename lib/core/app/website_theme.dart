import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/core/app/app_theme.dart';

/// A primary (buttons, the visitor's bubble, borders) and a secondary
/// (links, sparkles, aurora) colour. Hot reload cycles through these.
class AccentPair {
  final Color primary;
  final Color secondary;

  const AccentPair(this.primary, this.secondary);
}

/// The website's "Midnight aurora" theme: always dark, navy-ink surfaces,
/// and the accent pair on top. The admin app keeps [AppTheme].
class WebsiteTheme {
  WebsiteTheme._();

  /// Every primary keeps white text at 4.5:1 or more.
  static const List<AccentPair> accents = [
    AccentPair(AppColors.violet, AppColors.cyan), // default
    AccentPair(Color(0xFF0E7490), Color(0xFFA78BFA)), // cyan + lavender
    AccentPair(Color(0xFFDC2626), Color(0xFFFBBF24)), // red + amber
    AccentPair(Color(0xFF15803D), AppColors.cyan), // green + cyan
    AccentPair(Color(0xFFC026D3), Color(0xFFF472B6)), // magenta + pink
  ];

  static ThemeData build(AccentPair accent) {
    final base = AppTheme.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: accent.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: accent.primary,
          onPrimary: Colors.white,
          secondary: accent.secondary,
          onSecondary: AppColors.inkBackground,
          surface: AppColors.inkSurface,
          onSurface: AppColors.inkText,
          surfaceContainerHighest: AppColors.inkSurfaceHigh,
          onSurfaceVariant: AppColors.inkTextSecondary,
          outline: AppColors.inkBorder,
          outlineVariant: AppColors.inkBorder,
        );

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.inkBackground,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inkSurface,
        hintStyle: const TextStyle(
          color: AppColors.inkTextSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        border: border(AppColors.inkBorder),
        enabledBorder: border(AppColors.inkBorder),
        focusedBorder: border(accent.primary, 2),
        errorBorder: border(Colors.red, 1.5),
        focusedErrorBorder: border(Colors.red, 2),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.inkText,
          side: BorderSide(color: accent.primary),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.inkSurface,
        dragHandleColor: AppColors.inkTextSecondary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.inkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent.secondary,
        selectionColor: accent.primary.withValues(alpha: 0.4),
        selectionHandleColor: accent.primary,
      ),
    );
  }
}
