import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/shared/glass_theme.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/model/simon_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/provider/simon_says_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/utils/simon_theme.dart';
import 'package:mivo/feature/screen/widgets/mini_games/simon_says/widgets/simon_button.dart';
import 'package:provider/provider.dart';

/// Shown after finishing a non-secret level.
class LevelCompleteView extends StatelessWidget {
  const LevelCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SimonSaysProvider>();
    final next = game.nextLevel;

    return Column(
      children: [
        _PopIn(
          child: Icon(
            Icons.stars_rounded,
            size: 64,
            color: SimonTheme.levelColor(
              game.currentLevel ?? SimonLevel.easy,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Level Complete!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: GlassTheme.textPrimary(context),
          ),
        ),
        if (game.secretJustUnlocked) ...[
          const SizedBox(height: 12),
          const _SecretUnlockedBadge(),
        ],
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            if (next != null)
              SimonButton(
                icon: Icons.arrow_forward_rounded,
                label: 'Next: ${next.label}',
                isPrimary: true,
                onTap: () =>
                    context.read<SimonSaysProvider>().startLevel(next),
              ),
            SimonButton(
              icon: Icons.grid_view_rounded,
              label: 'Levels',
              onTap: () =>
                  context.read<SimonSaysProvider>().goToLevelSelect(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Shown when the player repeats the sequence wrong.
class GameOverView extends StatelessWidget {
  const GameOverView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<SimonSaysProvider>();
    final level = game.currentLevel;

    return Column(
      children: [
        const _Shake(
          child: Icon(
            Icons.close_rounded,
            size: 64,
            color: Color(0xFFFF4D5E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Game Over',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: GlassTheme.textPrimary(context),
          ),
        ),
        if (level != null) ...[
          const SizedBox(height: 4),
          Text(
            '${level.label} — reached round ${game.round} / ${game.maxRounds}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: GlassTheme.textSecondary(context),
            ),
          ),
        ],
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            SimonButton(
              icon: Icons.refresh_rounded,
              label: 'Retry Level',
              isPrimary: true,
              onTap: () => context.read<SimonSaysProvider>().retryLevel(),
            ),
            SimonButton(
              icon: Icons.grid_view_rounded,
              label: 'Levels',
              onTap: () =>
                  context.read<SimonSaysProvider>().goToLevelSelect(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Full celebration after beating the secret level.
class MasteredView extends StatelessWidget {
  const MasteredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PopIn(
          child: _TrophyPulse(
            child: Text('🏆', style: TextStyle(fontSize: 64)),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Congratulations!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF9C6BFF),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'You mastered Simon Says! ✨🎉',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: GlassTheme.textPrimary(context),
          ),
        ),
        const SizedBox(height: 18),
        SimonButton(
          icon: Icons.grid_view_rounded,
          label: 'Back to Levels',
          isPrimary: true,
          onTap: () => context.read<SimonSaysProvider>().goToLevelSelect(),
        ),
      ],
    );
  }
}

/// 🔒 → 🔓 badge shown when the secret level unlocks.
class _SecretUnlockedBadge extends StatelessWidget {
  const _SecretUnlockedBadge();

  @override
  Widget build(BuildContext context) {
    const secretColor = Color(0xFF9C6BFF);

    return _PopIn(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              secretColor.withValues(alpha: 0.25),
              secretColor.withValues(alpha: 0.1),
            ],
          ),
          border: Border.all(color: secretColor.withValues(alpha: 0.6)),
        ),
        child: const Text(
          '🔒 → 🔓 Secret Level Unlocked',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: secretColor,
          ),
        ),
      ),
    );
  }
}

/// Elastic scale-in entrance.
class _PopIn extends StatelessWidget {
  const _PopIn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: child,
    );
  }
}

/// Horizontal shake entrance for the game-over icon.
class _Shake extends StatelessWidget {
  const _Shake({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) => Transform.translate(
        offset: Offset(sin(value * pi * 5) * 8 * (1 - value), 0),
        child: child,
      ),
      child: child,
    );
  }
}

/// Endless gentle pulse for the trophy.
class _TrophyPulse extends StatefulWidget {
  const _TrophyPulse({required this.child});

  final Widget child;

  @override
  State<_TrophyPulse> createState() => _TrophyPulseState();
}

class _TrophyPulseState extends State<_TrophyPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 0.95,
    end: 1.1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
