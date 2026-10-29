import 'dart:math';

import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/game_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/board_utils.dart';

/// AI opponent. Plays [Player.o] against the human's [Player.x].
///
/// - Easy: random move.
/// - Medium: 70% minimax, 30% random.
/// - Hard: pure minimax (never loses).
class TicTacToeAi {
  final Random _random = Random();

  /// Returns the chosen cell index, or -1 if the board is full.
  /// [board] is mutated during search, so pass a copy of the live board.
  int chooseMove(List<Player?> board, Difficulty difficulty) {
    if (BoardUtils.availableMoves(board).isEmpty) return -1;
    return switch (difficulty) {
      Difficulty.easy => _randomMove(board),
      Difficulty.medium => _random.nextDouble() < 0.7
          ? _bestMove(board)
          : _randomMove(board),
      Difficulty.hard => _bestMove(board),
    };
  }

  int _randomMove(List<Player?> board) {
    final moves = BoardUtils.availableMoves(board);
    return moves[_random.nextInt(moves.length)];
  }

  int _bestMove(List<Player?> board) {
    var bestScore = -1000;
    var bestMove = -1;
    for (final move in BoardUtils.availableMoves(board)) {
      board[move] = Player.o;
      final score = _minimax(board, 1, false);
      board[move] = null;
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove;
  }

  /// Scores favor faster wins and slower losses via [depth].
  int _minimax(List<Player?> board, int depth, bool isMaximizing) {
    final line = BoardUtils.winningLine(board);
    if (line != null) {
      return board[line[0]] == Player.o ? 10 - depth : depth - 10;
    }
    if (BoardUtils.isFull(board)) return 0;

    var best = isMaximizing ? -1000 : 1000;
    for (final move in BoardUtils.availableMoves(board)) {
      board[move] = isMaximizing ? Player.o : Player.x;
      final score = _minimax(board, depth + 1, !isMaximizing);
      board[move] = null;
      best = isMaximizing ? max(best, score) : min(best, score);
    }
    return best;
  }
}
