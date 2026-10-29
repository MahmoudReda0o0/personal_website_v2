import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_theme.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/provider/simon_says_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/utils/simon_theme.dart';
import 'package:provider/provider.dart';

/// Shown during gameplay: back button, level name, "Round X / Y" and
/// an animated status line (watch / your turn).
class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SimonSaysProvider>();
    final level = game.currentLevel;
    if (level == null) return const SizedBox.shrink();

    final isWatching = game.phase == SimonPhase.showing;
    final statusText = isWatching ? 'Watch the sequence…' : 'Your turn!';
    final levelColor = SimonTheme.levelColor(level);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () =>
                  context.read<SimonSaysProvider>().goToLevelSelect(),
              tooltip: 'Back to levels',
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: GlassTheme.textSecondary(context),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    level.label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: levelColor,
                    ),
                  ),
                  Text(
                    'Round ${game.round} / ${game.maxRounds}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: GlassTheme.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            // Balances the back button so the title stays centered.
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            statusText,
            key: ValueKey(statusText),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isWatching
                  ? GlassTheme.textSecondary(context)
                  : levelColor,
            ),
          ),
        ),
      ],
    );
  }
}
