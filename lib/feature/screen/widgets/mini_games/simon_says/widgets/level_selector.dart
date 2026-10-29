import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_theme.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/provider/simon_says_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/utils/simon_theme.dart';
import 'package:provider/provider.dart';

/// The four level cards. Locked levels show a lock; the secret level stays
/// disguised as "???" until unlocked, then scales in with a reveal animation.
class LevelSelector extends StatelessWidget {
  const LevelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SimonSaysProvider>();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        for (final level in SimonLevel.values)
          _LevelCard(
            level: level,
            isUnlocked: game.isUnlocked(level),
            justRevealed:
                level == SimonLevel.secret && game.secretJustUnlocked,
          ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    required this.justRevealed,
  });

  final SimonLevel level;
  final bool isUnlocked;
  final bool justRevealed;

  @override
  Widget build(BuildContext context) {
    final color = SimonTheme.levelColor(level);
    final isSecret = level == SimonLevel.secret;
    final title = isSecret && !isUnlocked ? '???' : level.label;

    Widget card = GestureDetector(
      onTap: isUnlocked
          ? () => context.read<SimonSaysProvider>().startLevel(level)
          : null,
      child: MouseRegion(
        cursor: isUnlocked ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isUnlocked ? 1 : 0.5,
          child: Container(
            width: 128,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: GlassTheme.cellFill(context),
              border: Border.all(
                color: isUnlocked
                    ? color.withValues(alpha: 0.6)
                    : GlassTheme.glassBorder(context),
                width: isUnlocked ? 1.5 : 1,
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Icon(
                  isUnlocked
                      ? (isSecret
                            ? Icons.auto_awesome_rounded
                            : Icons.play_circle_fill_rounded)
                      : Icons.lock_rounded,
                  size: 30,
                  color: isUnlocked
                      ? color
                      : GlassTheme.textSecondary(context),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isUnlocked
                        ? GlassTheme.textPrimary(context)
                        : GlassTheme.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isSecret && !isUnlocked
                      ? 'Locked'
                      : '${level.maxRounds} colors',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: GlassTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (justRevealed) {
      card = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        builder: (context, value, child) =>
            Transform.scale(scale: value, child: child),
        child: card,
      );
    }

    return card;
  }
}
