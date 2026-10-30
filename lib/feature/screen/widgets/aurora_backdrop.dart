import 'dart:math';

import 'package:flutter/material.dart';

/// Soft aurora glow (primary + secondary colour) behind [child], drifting
/// very slowly. It follows the theme, so a hot reload re-colours it, and it
/// stays still when the visitor's device asks for reduced motion.
///
/// The glow paints beyond the child's box on purpose; text never sits on it.
class AuroraBackdrop extends StatefulWidget {
  const AuroraBackdrop({super.key, required this.child});

  final Widget child;

  @override
  State<AuroraBackdrop> createState() => _AuroraBackdropState();
}

class _AuroraBackdropState extends State<AuroraBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      _drift.stop();
    } else if (!_drift.isAnimating) {
      _drift.repeat();
    }
  }

  @override
  void dispose() {
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _drift,
                builder: (context, _) => CustomPaint(
                  painter: _AuroraPainter(
                    primary: scheme.primary,
                    secondary: scheme.secondary,
                    phase: _drift.value * 2 * pi,
                  ),
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.primary,
    required this.secondary,
    required this.phase,
  });

  final Color primary;
  final Color secondary;
  final double phase;

  void _blob(Canvas canvas, Offset center, double radius, Color color,
      double alpha) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: alpha * 0.35),
          color.withValues(alpha: 0),
        ],
        stops: const [0, 0.45, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide * 0.8;
    // Wide, flat ellipses: the glow spreads sideways, not up into the
    // header text.
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(1.3, 0.78);
    _blob(
      canvas,
      Offset(-r * 0.3 + 14 * sin(phase), 8 * cos(phase)),
      r,
      primary,
      0.42,
    );
    _blob(
      canvas,
      Offset(r * 0.34 + 12 * cos(phase * 2), r * 0.12 + 8 * sin(phase * 2)),
      r * 0.8,
      secondary,
      0.26,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.phase != phase || old.primary != primary || old.secondary != secondary;
}
