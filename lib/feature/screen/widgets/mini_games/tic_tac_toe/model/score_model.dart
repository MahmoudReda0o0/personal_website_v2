/// Mutable scoreboard for the current session.
class ScoreModel {
  int playerWins = 0;
  int aiWins = 0;
  int draws = 0;

  void reset() {
    playerWins = 0;
    aiWins = 0;
    draws = 0;
  }
}
