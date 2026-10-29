import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/utils/simon_theme.dart';

/// One color pad. Lights up during playback and on correct presses.
class SimonPad extends StatelessWidget {
  const SimonPad({
    super.key,
    required this.color,
    required this.isLit,
    required this.enabled,
    required this.onTap,
  });

  final SimonColor color;
  final bool isLit;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final padColor = SimonTheme.padColor(color);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedScale(
          scale: isLit ? 1.06 : 1,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: padColor.withValues(alpha: isLit ? 1 : 0.3),
              border: Border.all(
                color: padColor.withValues(alpha: isLit ? 1 : 0.5),
                width: 2,
              ),
              boxShadow: isLit
                  ? [
                      BoxShadow(
                        color: padColor.withValues(alpha: 0.6),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
