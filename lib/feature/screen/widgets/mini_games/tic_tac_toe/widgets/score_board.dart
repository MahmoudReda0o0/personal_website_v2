import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/provider/tic_tac_toe_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/ttt_theme.dart';
import 'package:provider/provider.dart';

/// You / Draws / AI score tiles.
class ScoreBoard extends StatelessWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.watch<TicTacToeProvider>().score;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScoreTile(label: 'You', value: score.playerWins, color: TttTheme.xColor),
        const SizedBox(width: 10),
        _ScoreTile(label: 'Draws', value: score.draws, color: TttTheme.drawColor),
        const SizedBox(width: 10),
        _ScoreTile(label: 'AI', value: score.aiWins, color: TttTheme.oColor),
      ],
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: TttTheme.cellFill(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '$value',
              key: ValueKey(value),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: TttTheme.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
