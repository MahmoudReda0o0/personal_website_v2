import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_theme.dart';

/// Frosted-glass card used across the mini game sections.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: GlassTheme.glassBorder(context)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                GlassTheme.glassFill(context),
                GlassTheme.glassFill(context).withValues(
                  alpha: GlassTheme.isDark(context) ? 0.02 : 0.3,
                ),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
