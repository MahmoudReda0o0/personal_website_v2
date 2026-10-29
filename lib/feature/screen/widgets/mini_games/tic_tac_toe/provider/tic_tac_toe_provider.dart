import 'package:flutter/foundation.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/ai/tic_tac_toe_ai.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/game_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/score_model.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/board_utils.dart';

/// Holds all game state and rules. Widgets only render it and forward taps.
class TicTacToeProvider extends ChangeNotifier {
  final TicTacToeAi _ai = TicTacToeAi();

  List<Player?> board = List.filled(9, null);
  GameStatus status = GameStatus.playing;
  Difficulty difficulty = Difficulty.medium;
  List<int>? winningLine;
  bool isAiThinking = false;
  final ScoreModel score = ScoreModel();

  bool _disposed = false;

  /// Bumped on every restart so a pending AI turn from a previous round
  /// silently aborts instead of playing on the new board.
  int _round = 0;

  bool get isBoardLocked => isAiThinking || status != GameStatus.playing;

  Future<void> playCell(int index) async {
    if (isBoardLocked || board[index] != null) return;
    board[index] = Player.x;
    _evaluateBoard();
    notifyListeners();
    if (status == GameStatus.playing) {
      await _playAiTurn();
    }
  }

  Future<void> _playAiTurn() async {
    final round = _round;
    isAiThinking = true;
    notifyListeners();

    // Small pause so the AI move reads as a response, not an instant flash.
    await Future.delayed(const Duration(milliseconds: 450));
    if (_disposed || round != _round) return;

    final move = _ai.chooseMove(List.of(board), difficulty);
    if (move != -1) board[move] = Player.o;
    isAiThinking = false;
    _evaluateBoard();
    notifyListeners();
  }

  void _evaluateBoard() {
    final line = BoardUtils.winningLine(board);
    if (line != null) {
      winningLine = line;
      if (board[line[0]] == Player.x) {
        status = GameStatus.playerWin;
        score.playerWins++;
      } else {
        status = GameStatus.aiWin;
        score.aiWins++;
      }
    } else if (BoardUtils.isFull(board)) {
      status = GameStatus.draw;
      score.draws++;
    }
  }

  void restart() {
    _round++;
    board = List.filled(9, null);
    status = GameStatus.playing;
    winningLine = null;
    isAiThinking = false;
    notifyListeners();
  }

  void resetScore() {
    score.reset();
    notifyListeners();
  }

  void setDifficulty(Difficulty value) {
    if (value == difficulty) return;
    difficulty = value;
    restart();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
