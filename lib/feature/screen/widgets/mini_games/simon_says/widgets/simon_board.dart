import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/provider/simon_says_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/widgets/simon_pad.dart';
import 'package:provider/provider.dart';

/// The 2x2 grid of color pads.
class SimonBoard extends StatelessWidget {
  const SimonBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SimonSaysProvider>();
    final enabled = game.phase == SimonPhase.input;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            for (final color in SimonColor.values)
              SimonPad(
                color: color,
                isLit: game.litPad == color,
                enabled: enabled,
                onTap: () =>
                    context.read<SimonSaysProvider>().padPressed(color),
              ),
          ],
        ),
      ),
    );
  }
}
