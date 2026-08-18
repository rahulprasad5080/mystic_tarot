import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated Divine Loading Widget matching the screenshot design.
/// Features a floating, glowing "DIVINE GUIDANCE" card surrounded by
/// animated floating particles and smooth breathing glows.
class DivineLoadingWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showHeader;

  const DivineLoadingWidget({
    super.key,
    this.title = 'Connecting with your divine guidance...',
    this.subtitle = 'Your reading is being prepared.',
    this.showHeader = true,
  });

  @override
  State<DivineLoadingWidget> createState() => _DivineLoadingWidgetState();
}

class _DivineLoadingWidgetState extends State<DivineLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _particleController;

  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Floating card animation (up and down)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    // Glowing aura pulse animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.15, end: 0.38).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Floating orb particles continuous animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFFFFF);

    final content = Column(
      children: [
        if (widget.showHeader) ...[
          const SizedBox(height: 20),
          // Top Header Title "Divine Readings"
          const Text(
            'Divine Readings',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.4,
            ),
          ),
        ],

        // Central Interactive Canvas area with Card and Particles
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated Floating Particles around the card
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _OrbParticlesPainter(
                      progress: _particleController.value,
                    ),
                  );
                },
              ),

              // Floating & Glowing Center Card
              AnimatedBuilder(
                animation: Listenable.merge([
                  _floatController,
                  _glowController,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: _buildGlowingCard(_glowAnimation.value),
                  );
                },
              ),
            ],
          ),
        ),

        // Bottom Text Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );

    if (widget.showHeader) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(child: content),
      );
    }

    return Container(
      color: backgroundColor,
      child: content,
    );
  }

  /// Builds the center glowing card matching the screenshot design
  Widget _buildGlowingCard(double glowOpacity) {
    return Container(
      width: 220,
      height: 330,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE0F2FE),
          width: 1.5,
        ),
        boxShadow: [
          // Primary vibrant cyan glow matching mockup
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: glowOpacity),
            blurRadius: 36,
            spreadRadius: 6,
            offset: const Offset(0, 10),
          ),
          // Soft ambient sky blue aura
          BoxShadow(
            color: const Color(0xFF38BDF8).withValues(alpha: glowOpacity * 0.7),
            blurRadius: 50,
            spreadRadius: 14,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center Circular Sparkle Badge
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F9FF),
              border: Border.all(
                color: const Color(0xFFBAE6FD),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(
                    Icons.auto_awesome,
                    size: 38,
                    color: Color(0xFF38BDF8),
                  ),
                  Icon(
                    Icons.auto_awesome,
                    size: 24,
                    color: Color(0xFF0284C7),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // "DIVINE GUIDANCE" text inside card
          const Text(
            'DIVINE GUIDANCE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0284C7),
              letterSpacing: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter for ambient floating cyan particles matching the screenshot
class _OrbParticlesPainter extends CustomPainter {
  final double progress;

  _OrbParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Particle definitions based on exact placement in screenshot
    final particles = [
      // Top Left particle
      _ParticleSpec(
        baseOffset: Offset(center.dx - 120, center.dy - 120),
        size: 7.0,
        color: const Color(0xFF38BDF8),
        speed: 1.0,
        phase: 0.0,
      ),
      // Middle Left tiny particle
      _ParticleSpec(
        baseOffset: Offset(center.dx - 145, center.dy - 10),
        size: 4.5,
        color: const Color(0xFF38BDF8),
        speed: 0.8,
        phase: 1.2,
      ),
      // Bottom Left particle
      _ParticleSpec(
        baseOffset: Offset(center.dx - 100, center.dy + 110),
        size: 6.0,
        color: const Color(0xFF0284C7),
        speed: 1.2,
        phase: 2.5,
      ),
      // Right Upper particle
      _ParticleSpec(
        baseOffset: Offset(center.dx + 130, center.dy - 70),
        size: 11.0,
        color: const Color(0xFF7DD3FC),
        speed: 0.9,
        phase: 0.5,
      ),
      // Bottom Right particle
      _ParticleSpec(
        baseOffset: Offset(center.dx + 125, center.dy + 160),
        size: 7.5,
        color: const Color(0xFF38BDF8),
        speed: 1.1,
        phase: 3.1,
      ),
    ];

    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final dy = math.sin(t * 2 * math.pi) * 8.0;
      final dx = math.cos(t * 2 * math.pi) * 5.0;
      final opacity = (0.5 + 0.4 * math.sin(t * 2 * math.pi)).clamp(0.2, 0.95);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(p.baseOffset.dx + dx, p.baseOffset.dy + dy),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticleSpec {
  final Offset baseOffset;
  final double size;
  final Color color;
  final double speed;
  final double phase;

  _ParticleSpec({
    required this.baseOffset,
    required this.size,
    required this.color,
    required this.speed,
    required this.phase,
  });
}
