import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';

/// Colors for the Simon Says pads and level accents.
class SimonTheme {
  SimonTheme._();

  static Color padColor(SimonColor color) => switch (color) {
    SimonColor.green => const Color(0xFF2EE56B),
    SimonColor.red => const Color(0xFFFF4D5E),
    SimonColor.yellow => const Color(0xFFFFC93D),
    SimonColor.blue => const Color(0xFF3D8BFF),
  };

  static Color levelColor(SimonLevel level) => switch (level) {
    SimonLevel.easy => const Color(0xFF2EE56B),
    SimonLevel.medium => const Color(0xFFFFB74D),
    SimonLevel.hard => const Color(0xFFFF4D5E),
    SimonLevel.secret => const Color(0xFF9C6BFF),
  };
}
