import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Animated mystical background with softly twinkling stars over a light sky-blue gradient.
class MysticalBackground extends StatefulWidget {
  final Widget child;

  const MysticalBackground({super.key, required this.child});

  @override
  State<MysticalBackground> createState() => _MysticalBackgroundState();
}

class _MysticalBackgroundState extends State<MysticalBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    final random = Random();
    _stars = List.generate(60, (_) => _Star.random(random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Soft sky gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backgroundGradient,
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Animated stars
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _StarPainter(
                stars: _stars,
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        // Subtle radial glow
        Positioned(
          top: -100,
          left: 0,
          right: 0,
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  AppColors.primaryBlue.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  factory _Star.random(Random random) {
    return _Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 2 + 0.5,
      speed: random.nextDouble() * 0.5 + 0.5,
      opacity: random.nextDouble() * 0.6 + 0.2,
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  _StarPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle =
          (sin((animationValue * star.speed * 2 * pi) + star.x * 10) + 1) / 2;
      final currentOpacity = star.opacity * (0.15 + twinkle * 0.45);

      final paint = Paint()
        ..color = AppColors.primaryBlue.withValues(alpha: currentOpacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 0.5);

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => true;
}
