import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_container.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_theme.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glow_blob.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/provider/simon_says_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/widgets/level_selector.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/widgets/progress_header.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/widgets/result_views.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/widgets/simon_board.dart';
import 'package:provider/provider.dart';

/// Embeddable Simon Says game with a 4-level progression system.
/// Creates its own [SimonSaysProvider], so it can be dropped anywhere.
class SimonSaysSection extends StatelessWidget {
  const SimonSaysSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SimonSaysProvider(),
      child: const _SimonSaysCard(),
    );
  }
}

class _SimonSaysCard extends StatelessWidget {
  const _SimonSaysCard();

  @override
  Widget build(BuildContext context) {
    final phase = context.watch<SimonSaysProvider>().phase;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Stack(
            children: [
              const Positioned(
                top: -30,
                right: -20,
                child: GlowBlob(color: Color(0xFF2EE56B), size: 200),
              ),
              const Positioned(
                bottom: -40,
                left: -10,
                child: GlowBlob(color: Color(0xFF9C6BFF), size: 220),
              ),
              GlassContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const _SectionHeader(),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 0.95,
                            end: 1,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(_viewKey(phase)),
                        child: switch (phase) {
                          SimonPhase.levelSelect => const LevelSelector(),
                          SimonPhase.showing ||
                          SimonPhase.input => const Column(
                            children: [
                              ProgressHeader(),
                              SizedBox(height: 16),
                              SimonBoard(),
                            ],
                          ),
                          SimonPhase.levelComplete =>
                            const LevelCompleteView(),
                          SimonPhase.gameOver => const GameOverView(),
                          SimonPhase.mastered => const MasteredView(),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Showing and input share one view so the board doesn't cross-fade
  /// between playback and player turns.
  static String _viewKey(SimonPhase phase) => switch (phase) {
    SimonPhase.showing || SimonPhase.input => 'playing',
    _ => phase.name,
  };
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
              Icons.graphic_eq_rounded,
              color: Color(0xFF9C6BFF),
              size: 26,
            ),
            const SizedBox(width: 8),
            Text(
              'Simon Says',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: GlassTheme.textPrimary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Repeat the sequence and climb through the levels',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: GlassTheme.textSecondary(context),
          ),
        ),
      ],
    );
  }
}
