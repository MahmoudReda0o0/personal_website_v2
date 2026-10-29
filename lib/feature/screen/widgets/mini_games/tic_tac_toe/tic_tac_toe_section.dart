import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_container.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glow_blob.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/provider/tic_tac_toe_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/ttt_theme.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/widgets/difficulty_selector.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/widgets/game_board.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/widgets/game_controls.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/widgets/score_board.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/widgets/status_banner.dart';
import 'package:provider/provider.dart';

/// Embeddable Tic Tac Toe game — a portfolio section, not a screen.
/// Creates its own [TicTacToeProvider], so it can be dropped anywhere.
class TicTacToeSection extends StatelessWidget {
  const TicTacToeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TicTacToeProvider(),
      child: const _TicTacToeCard(),
    );
  }
}

class _TicTacToeCard extends StatelessWidget {
  const _TicTacToeCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Stack(
            children: [
              // Soft gradient blobs behind the glass so the blur reads.
              const Positioned(
                top: -30,
                left: -20,
                child: GlowBlob(color: AppColors.primary, size: 220),
              ),
              const Positioned(
                bottom: -40,
                right: -10,
                child: GlowBlob(color: TttTheme.oColor, size: 200),
              ),
              GlassContainer(
                padding: const EdgeInsets.all(24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 620;
                    return Column(
                      children: [
                        const _SectionHeader(),
                        const SizedBox(height: 20),
                        if (isWide)
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: Center(child: GameBoard())),
                              SizedBox(width: 24),
                              Expanded(child: _SidePanel()),
                            ],
                          )
                        else
                          const Column(
                            children: [
                              DifficultySelector(),
                              SizedBox(height: 16),
                              StatusBanner(),
                              SizedBox(height: 16),
                              GameBoard(),
                              SizedBox(height: 20),
                              ScoreBoard(),
                              SizedBox(height: 16),
                              GameControls(),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DifficultySelector(),
        SizedBox(height: 20),
        StatusBanner(),
        SizedBox(height: 20),
        ScoreBoard(),
        SizedBox(height: 20),
        GameControls(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_esports_rounded,
              color: AppColors.primary,
              size: 26,
            ),
            const SizedBox(width: 8),
            Text(
              'Tic Tac Toe',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: TttTheme.textPrimary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Can you beat the AI?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: TttTheme.textSecondary(context),
          ),
        ),
      ],
    );
  }
}
