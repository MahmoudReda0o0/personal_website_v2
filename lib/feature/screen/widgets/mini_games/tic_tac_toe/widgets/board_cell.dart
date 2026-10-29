import 'package:flutter/material.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/model/game_enums.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/ttt_theme.dart';

/// A single board cell. Renders its mark with a pop-in animation and a
/// pulsing glow when it is part of the winning line.
class BoardCell extends StatelessWidget {
  const BoardCell({
    super.key,
    required this.value,
    required this.isWinning,
    required this.dimmed,
    required this.onTap,
  });

  final Player? value;
  final bool isWinning;

  /// True when the round ended and this cell is NOT part of the winning line.
  final bool dimmed;

  final VoidCallback onTap;

  Color get _markColor =>
      value == Player.x ? TttTheme.xColor : TttTheme.oColor;

  @override
  Widget build(BuildContext context) {
    final cell = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isWinning
            ? _markColor.withValues(alpha: 0.18)
            : TttTheme.cellFill(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWinning
              ? _markColor.withValues(alpha: 0.8)
              : TttTheme.glassBorder(context),
          width: isWinning ? 2 : 1,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.elasticOut,
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: value == null
              ? const SizedBox.shrink()
              : LayoutBuilder(
                  key: ValueKey(value),
                  builder: (context, constraints) => Text(
                    value == Player.x ? 'X' : 'O',
                    style: TextStyle(
                      fontSize: constraints.maxHeight * 0.55,
                      fontWeight: FontWeight.w800,
                      color: _markColor,
                      shadows: [
                        Shadow(
                          color: _markColor.withValues(alpha: 0.6),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: value == null && !dimmed
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: dimmed ? 0.35 : 1,
          child: isWinning ? _WinningPulse(child: cell) : cell,
        ),
      ),
    );
  }
}

/// Repeating scale pulse for winning cells.
class _WinningPulse extends StatefulWidget {
  const _WinningPulse({required this.child});

  final Widget child;

  @override
  State<_WinningPulse> createState() => _WinningPulseState();
}

class _WinningPulseState extends State<_WinningPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  )..repeat(reverse: true);

  late final Animation<double> _scale = Tween<double>(
    begin: 0.96,
    end: 1.06,
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
