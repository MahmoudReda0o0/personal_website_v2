import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/dev_tools/inspect_catalog.dart';
import 'package:mivo/feature/screen/widgets/dev_tools/inspect_target.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/simon_says_section.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/tic_tac_toe_section.dart';

class GameSection extends StatelessWidget {
  const GameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        InspectTarget(
          info: InspectCatalog.ticTacToe,
          child: TicTacToeSection(),
        ),
        InspectTarget(
          info: InspectCatalog.simonSays,
          child: SimonSaysSection(),
        ),
        // Future games...
        // RockPaperScissorsSection(),
        // MemoryGameSection(),
      ],
    );
  }
}
