/// The two players. The human always plays [Player.x], the AI plays [Player.o].
enum Player { x, o }

/// Lifecycle of a single round.
enum GameStatus { playing, playerWin, aiWin, draw }

/// AI difficulty levels.
enum Difficulty {
  easy,
  medium,
  hard;

  String get label => switch (this) {
    Difficulty.easy => 'Easy',
    Difficulty.medium => 'Medium',
    Difficulty.hard => 'Hard',
  };
}
