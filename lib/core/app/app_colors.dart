import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF402EDC);

  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFFA0A0A0);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // ---- Website "Midnight aurora" palette (website screen only) ----
  // Deep navy-ink instead of flat gray, one saturated violet for actions,
  // cyan as the second colour (matches the inspector and the games).
  static const Color inkBackground = Color(0xFF0B1022);
  static const Color inkSurface = Color(0xFF151B36);
  static const Color inkSurfaceHigh = Color(0xFF1C2347);
  static const Color inkBorder = Color(0xFF2A3260);
  static const Color inkText = Color(0xFFE6E9F5); // 14:1 on inkSurface
  static const Color inkTextSecondary = Color(0xFF9AA3C7); // 6.8:1
  static const Color violet = Color(0xFF6D5BFF); // white on it: 4.6:1
  static const Color cyan = Color(0xFF22D3EE);

  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkBorder = Color(0xFF3A3A3A);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
}
