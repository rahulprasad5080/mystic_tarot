import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state/providers/auth_provider.dart';

/// Clean, high-converting Google Login Screen matching Divine Readings design.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = ref.read(authServiceProvider);

    try {
      final credential = await authService.signInWithGoogle();
      if (credential != null && mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Google Sign-In was cancelled or failed.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Google sign in failed.';
      });
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      // Fallback: Proceed to home
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = ref.read(authServiceProvider);

    try {
      await authService.signInAnonymously();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE2EAF8),
              Color(0xFFEFF4FC),
              Color(0xFFE8EEFA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Animated Circular Sparkle Logo Badge
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final val = _animController.value;
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF0C4670,
                                ).withValues(alpha: 0.08 + (val * 0.12)),
                                blurRadius: 20 + (val * 12),
                                spreadRadius: 2 + (val * 4),
                                offset: const Offset(0, 8),
                              ),
                              BoxShadow(
                                color: const Color(
                                  0xFF38BDF8,
                                ).withValues(alpha: val * 0.25),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/logo.jpeg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 38,
                                    color: Color(0xFF0C4670),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // App Name Title
                  Text(
                    'Ably Tarot Card Reading',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0C4670),
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    'Begin your cosmic journey',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF5C6B73),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Main White Login Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F2942).withValues(alpha: 0.06),
                          blurRadius: 30,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_errorMessage != null) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFFCA5A5)),
                            ),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFDC2626),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],

                        // Continue with Google Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _handleGoogleSignIn,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0F172A),
                              side: const BorderSide(
                                color: Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF0C4670),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Google 'G' Multi-Color Logo
                                      const _GoogleLogoWidget(size: 22),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Continue with Google',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Terms of Service and Privacy Policy Note
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text.rich(
                            TextSpan(
                              text: 'By continuing, you agree to our ',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF64748B),
                                height: 1.45,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0C4670),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0C4670),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Guest Mode Option (subtle)
                  TextButton(
                    onPressed: _isLoading ? null : _continueAsGuest,
                    child: Text(
                      'Skip for now (Guest)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper widget to draw authentic multi-colored Google logo
class _GoogleLogoWidget extends StatelessWidget {
  final double size;
  const _GoogleLogoWidget({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPainterWidget(size: size),
    );
  }
}

class CustomPainterWidget extends StatelessWidget {
  final double size;
  const CustomPainterWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Scale canvas to 24x24 standard vector viewport
    canvas.scale(w / 24.0, h / 24.0);

    final Path redPath = Path()
      ..moveTo(12.0, 5.0)
      ..cubicTo(14.8, 5.0, 17.0, 6.0, 18.6, 7.5)
      ..lineTo(22.0, 4.1)
      ..cubicTo(19.3, 1.6, 15.9, 0.0, 12.0, 0.0)
      ..cubicTo(7.3, 0.0, 3.3, 2.7, 1.3, 6.6)
      ..lineTo(5.2, 9.6)
      ..cubicTo(6.1, 6.9, 8.8, 5.0, 12.0, 5.0)
      ..close();

    final Path yellowPath = Path()
      ..moveTo(5.2, 9.6)
      ..cubicTo(4.7, 11.0, 4.4, 12.5, 4.4, 14.0)
      ..cubicTo(4.4, 15.5, 4.7, 17.0, 5.2, 18.4)
      ..lineTo(1.3, 21.4)
      ..cubicTo(0.5, 19.1, 0.0, 16.6, 0.0, 14.0)
      ..cubicTo(0.0, 11.4, 0.5, 8.9, 1.3, 6.6)
      ..lineTo(5.2, 9.6)
      ..close();

    final Path greenPath = Path()
      ..moveTo(12.0, 23.0)
      ..cubicTo(15.9, 23.0, 19.2, 21.7, 21.6, 19.5)
      ..lineTo(17.8, 16.5)
      ..cubicTo(16.4, 17.5, 14.4, 18.1, 12.0, 18.1)
      ..cubicTo(8.8, 18.1, 6.1, 16.2, 5.2, 13.5)
      ..lineTo(1.3, 16.5)
      ..cubicTo(3.3, 20.4, 7.3, 23.0, 12.0, 23.0)
      ..close();

    final Path bluePath = Path()
      ..moveTo(23.5, 14.3)
      ..cubicTo(23.7, 13.5, 23.8, 12.7, 23.8, 11.9)
      ..cubicTo(23.8, 11.1, 23.7, 10.3, 23.5, 9.5)
      ..lineTo(12.0, 9.5)
      ..lineTo(12.0, 14.3)
      ..lineTo(18.6, 14.3)
      ..cubicTo(18.2, 16.0, 17.1, 17.3, 15.6, 18.2)
      ..lineTo(19.4, 21.2)
      ..cubicTo(21.9, 18.9, 23.5, 15.4, 23.5, 14.3)
      ..close();

    canvas.drawPath(redPath, Paint()..color = const Color(0xFFEA4335));
    canvas.drawPath(yellowPath, Paint()..color = const Color(0xFFFBBC05));
    canvas.drawPath(greenPath, Paint()..color = const Color(0xFF34A853));
    canvas.drawPath(bluePath, Paint()..color = const Color(0xFF4285F4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
