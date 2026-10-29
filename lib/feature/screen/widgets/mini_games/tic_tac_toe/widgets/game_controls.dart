import 'package:flutter/material.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/provider/tic_tac_toe_provider.dart';
import 'package:mivo/feature/screen/widgets/mini_games/tic_tac_toe/utils/ttt_theme.dart';
import 'package:provider/provider.dart';

/// Restart round + reset score buttons.
class GameControls extends StatelessWidget {
  const GameControls({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.read<TicTacToeProvider>();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _ControlButton(
          icon: Icons.refresh_rounded,
          label: 'Restart',
          isPrimary: true,
          onTap: game.restart,
        ),
        _ControlButton(
          icon: Icons.restore_rounded,
          label: 'Reset Score',
          isPrimary: false,
          onTap: game.resetScore,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary ? Colors.white : TttTheme.textPrimary(context);

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: isPrimary
                ? const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF7B5CFF)],
                  )
                : null,
            color: isPrimary ? null : TttTheme.cellFill(context),
            border: isPrimary
                ? null
                : Border.all(color: TttTheme.glassBorder(context)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
