import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import 'glow_orb.dart';

/// Premium gradient hero header for the home screen.
///
/// A sky-blue gradient card with soft glow orbs, a sparkle accent, and the
/// localized app title / tagline. Includes the language switcher action.
class HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String languageTooltip;
  final VoidCallback onLanguageTap;

  const HeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.languageTooltip,
    required this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.accentGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: Stack(
          children: [
            // Soft glow orbs
            const Positioned(
              top: -70,
              right: -50,
              child: GlowOrb(size: 190, opacity: 0.22),
            ),
            const Positioned(
              bottom: -80,
              left: -40,
              child: GlowOrb(size: 170, opacity: 0.14),
            ),

            // Faint sparkle accent
            const Positioned(
              top: 26,
              right: 68,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Color(0x40FFFFFF),
                size: 34,
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 12, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with sparkle badge
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                title,
                                style: AppTextStyles.displaySmall.copyWith(
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.language_rounded),
                        color: Colors.white,
                        tooltip: languageTooltip,
                        onPressed: onLanguageTap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
