import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/simon_says_section.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/tic_tac_toe_section.dart';

class GameSection extends StatelessWidget {
  const GameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TicTacToeSection(),
        SimonSaysSection(),
        // Future games...
        // RockPaperScissorsSection(),
        // MemoryGameSection(),
      ],
    );
  }
}
