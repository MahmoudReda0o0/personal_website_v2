import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/game_enums.dart';

/// Pure helpers over a 9-cell board (`List<Player?>` of length 9).
class BoardUtils {
  BoardUtils._();

  static const List<List<int>> winPatterns = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  /// Returns the winning line indices, or null if nobody has won yet.
  static List<int>? winningLine(List<Player?> board) {
    for (final pattern in winPatterns) {
      final first = board[pattern[0]];
      if (first != null &&
          first == board[pattern[1]] &&
          first == board[pattern[2]]) {
        return pattern;
      }
    }
    return null;
  }

  static bool isFull(List<Player?> board) =>
      board.every((cell) => cell != null);

  static List<int> availableMoves(List<Player?> board) => [
    for (int i = 0; i < board.length; i++)
      if (board[i] == null) i,
  ];
}
