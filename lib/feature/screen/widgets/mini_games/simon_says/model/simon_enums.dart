/// The four color pads.
enum SimonColor { green, red, yellow, blue }

/// Progression levels. Each level ends once the sequence reaches [maxRounds].
enum SimonLevel {
  easy('Easy', 4),
  medium('Medium', 6),
  hard('Hard', 8),
  secret('Secret', 10);

  const SimonLevel(this.label, this.maxRounds);

  final String label;
  final int maxRounds;

  SimonLevel? get next => index + 1 < SimonLevel.values.length
      ? SimonLevel.values[index + 1]
      : null;
}

/// What the game is currently doing.
enum SimonPhase {
  levelSelect,
  showing,
  input,
  levelComplete,
  gameOver,
  mastered,
}
