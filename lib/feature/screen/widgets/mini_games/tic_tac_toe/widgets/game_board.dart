import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/game_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/provider/tic_tac_toe_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/widgets/board_cell.dart';
import 'package:provider/provider.dart';

/// The 3x3 grid. Always square, capped at a comfortable size.
class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<TicTacToeProvider>();
    final roundOver = game.status != GameStatus.playing;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final isWinning = game.winningLine?.contains(index) ?? false;
            return BoardCell(
              value: game.board[index],
              isWinning: isWinning,
              dimmed: roundOver && game.winningLine != null && !isWinning,
              onTap: () => context.read<TicTacToeProvider>().playCell(index),
            );
          },
        ),
      ),
    );
  }
}
