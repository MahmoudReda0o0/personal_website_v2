import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';

/// All Simon Says rules and progression state. Widgets only render and
/// forward pad taps / button presses.
class SimonSaysProvider extends ChangeNotifier {
  final Random _random = Random();

  /// Unlocked levels for this session only (no persistence by design).
  final Set<SimonLevel> unlocked = {SimonLevel.easy};

  SimonLevel? currentLevel;
  SimonPhase phase = SimonPhase.levelSelect;
  final List<SimonColor> sequence = [];
  SimonColor? litPad;

  /// True right after completing Hard, to drive the secret reveal animation.
  bool secretJustUnlocked = false;

  int _inputIndex = 0;
  bool _disposed = false;

  /// Bumped whenever the current playback/round becomes obsolete so that
  /// pending delayed steps abort instead of mutating the new state.
  int _session = 0;

  int get round => sequence.length;
  int get maxRounds => currentLevel?.maxRounds ?? 0;

  bool isUnlocked(SimonLevel level) => unlocked.contains(level);

  /// The level to offer as "Next" on the level-complete view.
  SimonLevel? get nextLevel {
    final next = currentLevel?.next;
    return next != null && unlocked.contains(next) ? next : null;
  }

  Future<void> startLevel(SimonLevel level) async {
    if (!isUnlocked(level)) return;
    currentLevel = level;
    secretJustUnlocked = false;
    sequence
      ..clear()
      ..add(_randomColor());
    await _playSequence();
  }

  Future<void> _playSequence() async {
    final session = ++_session;
    phase = SimonPhase.showing;
    litPad = null;
    notifyListeners();
    if (!await _wait(700, session)) return;

    for (final color in sequence) {
      litPad = color;
      notifyListeners();
      if (!await _wait(450, session)) return;
      litPad = null;
      notifyListeners();
      if (!await _wait(200, session)) return;
    }

    _inputIndex = 0;
    phase = SimonPhase.input;
    notifyListeners();
  }

  Future<void> padPressed(SimonColor color) async {
    if (phase != SimonPhase.input) return;

    if (color != sequence[_inputIndex]) {
      _session++;
      litPad = null;
      phase = SimonPhase.gameOver;
      notifyListeners();
      return;
    }

    _inputIndex++;
    final session = _session;
    litPad = color;
    notifyListeners();

    if (_inputIndex >= sequence.length) {
      // Round repeated correctly.
      if (sequence.length >= maxRounds) {
        if (!await _wait(350, session)) return;
        _completeLevel();
      } else {
        if (!await _wait(500, session)) return;
        sequence.add(_randomColor());
        await _playSequence();
      }
      return;
    }

    // Clear the press flash unless another press replaced it already.
    if (!await _wait(220, session)) return;
    if (litPad == color && phase == SimonPhase.input) {
      litPad = null;
      notifyListeners();
    }
  }

  void _completeLevel() {
    final level = currentLevel!;
    _session++;
    litPad = null;
    if (level == SimonLevel.secret) {
      phase = SimonPhase.mastered;
    } else {
      final next = level.next!;
      if (unlocked.add(next) && next == SimonLevel.secret) {
        secretJustUnlocked = true;
      }
      phase = SimonPhase.levelComplete;
    }
    notifyListeners();
  }

  void retryLevel() {
    final level = currentLevel;
    if (level != null) startLevel(level);
  }

  void goToLevelSelect() {
    _session++;
    currentLevel = null;
    sequence.clear();
    litPad = null;
    phase = SimonPhase.levelSelect;
    notifyListeners();
  }

  Future<bool> _wait(int ms, int session) async {
    await Future.delayed(Duration(milliseconds: ms));
    return !_disposed && session == _session;
  }

  SimonColor _randomColor() =>
      SimonColor.values[_random.nextInt(SimonColor.values.length)];

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
