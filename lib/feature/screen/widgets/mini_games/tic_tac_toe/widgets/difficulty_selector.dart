import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/game_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/provider/tic_tac_toe_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/ttt_theme.dart';
import 'package:provider/provider.dart';

/// Easy / Medium / Hard segmented chips.
class DifficultySelector extends StatelessWidget {
  const DifficultySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context
        .watch<TicTacToeProvider>()
        .difficulty;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        for (final difficulty in Difficulty.values)
          _DifficultyChip(
            difficulty: difficulty,
            isSelected: difficulty == selected,
          ),
      ],
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.difficulty, required this.isSelected});

  final Difficulty difficulty;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<TicTacToeProvider>().setDifficulty(difficulty),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF7B5CFF)],
                  )
                : null,
            color: isSelected ? null : TttTheme.cellFill(context),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : TttTheme.glassBorder(context),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            difficulty.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : TttTheme.textPrimary(context),
            ),
          ),
        ),
      ),
    );
  }
}
