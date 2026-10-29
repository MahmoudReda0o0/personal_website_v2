import 'package:flutter/material.dart';

/// Soft radial gradient circle placed behind glass cards so the blur reads.
class GlowBlob extends StatelessWidget {
  const GlowBlob({super.key, required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
