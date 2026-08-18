import 'package:flutter/material.dart';

/// Soft radial white glow used as a decorative orb in gradient headers.
class GlowOrb extends StatelessWidget {
  final double size;
  final double opacity;

  const GlowOrb({super.key, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: opacity),
            Colors.white.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
