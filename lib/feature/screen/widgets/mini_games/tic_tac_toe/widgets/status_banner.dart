import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/game_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/provider/tic_tac_toe_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/ttt_theme.dart';
import 'package:provider/provider.dart';

/// Animated one-line status: whose turn it is / who won / draw.
class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<TicTacToeProvider>();

    final (text, color) = switch (game.status) {
      GameStatus.playing when game.isAiThinking => (
        'AI is thinking…',
        TttTheme.oColor,
      ),
      GameStatus.playing => ('Your turn — you are X', TttTheme.xColor),
      GameStatus.playerWin => ('🎉 You win!', TttTheme.xColor),
      GameStatus.aiWin => ('🤖 AI wins!', TttTheme.oColor),
      GameStatus.draw => ("🤝 It's a draw", TttTheme.drawColor),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Text(
        text,
        key: ValueKey(text),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
