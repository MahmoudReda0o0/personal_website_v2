import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_theme.dart';

/// Pill button used by the Simon Says views.
class SimonButton extends StatelessWidget {
  const SimonButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary
        ? Colors.white
        : GlassTheme.textPrimary(context);

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF7B5CFF)],
                  )
                : null,
            color: isPrimary ? null : GlassTheme.cellFill(context),
            border: isPrimary
                ? null
                : Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
