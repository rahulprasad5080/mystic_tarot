import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../state/providers/auth_provider.dart';

/// Premium, sleek Settings screen matching modern design guidelines.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const backgroundColor = Color(0xFFF8FAFC);
    final user = ref.watch(currentUserProvider);
    final authService = ref.watch(authServiceProvider);

    final displayName = user?.displayName != null && user!.displayName!.isNotEmpty
        ? user.displayName!
        : (user?.isAnonymous == true ? 'Guest Seeker' : 'Mystic Traveler');

    final emailText = user?.email != null && user!.email!.isNotEmpty
        ? user.email!
        : (user?.isAnonymous == true
            ? 'Guest Account'
            : (user != null ? 'Registered User' : 'Not Signed In'));

    final initialLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/language');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEBF5FF),
                        border: Border.all(
                          color: const Color(0xFFD6E9FA),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: Color(0xFF006884),
                        size: 20,
                      ),
                    ),
                  ),

                  // Header Title
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006884),
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(width: 38),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Premium User Profile Card Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFEAECF0),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF101828).withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar Ring with Outer Gradient
                          Container(
                            width: 92,
                            height: 92,
                            padding: const EdgeInsets.all(3.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF0088B2),
                                  Color(0xFF006884),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(2.0),
                              child: ClipOval(
                                child: user?.photoURL != null &&
                                        user!.photoURL!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: user.photoURL!,
                                        fit: BoxFit.cover,
                                        width: 84,
                                        height: 84,
                                        placeholder: (ctx, url) => Container(
                                          color: const Color(0xFFEBF5FF),
                                          child: const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF006884),
                                              ),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (ctx, url, err) =>
                                            _buildAvatarFallback(initialLetter),
                                      )
                                    : _buildAvatarFallback(initialLetter),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // User Display Name
                          Text(
                            displayName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF101828),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Email Address Pill Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFF1F5F9),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.mail_outline_rounded,
                                  size: 13,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  emailText,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Section Header: ABOUT & SUPPORT
                    _buildSectionHeader('ABOUT & SUPPORT'),
                    const SizedBox(height: 10),
                    _buildCardContainer(
                      children: [
                        _buildSettingsRow(
                          icon: Icons.star_outline_rounded,
                          title: 'Rate App',
                          onTap: () => _openPlayStore(),
                        ),
                        const Divider(height: 1, color: Color(0xFFF2F4F7)),
                        _buildSettingsRow(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFF2F4F7)),
                        _buildSettingsRow(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Log Out / Sign In Button directly below Terms & Conditions Card
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (user != null) {
                            await authService.signOut();
                          }
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: user != null
                              ? const Color(0xFFFFF2F2)
                              : const Color(0xFFEBF5FF),
                          foregroundColor: user != null
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF006884),
                          elevation: 0,
                          side: BorderSide(
                            color: user != null
                                ? const Color(0xFFFEE2E2)
                                : const Color(0xFFD6E9FA),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              user != null
                                  ? Icons.logout_rounded
                                  : Icons.login_rounded,
                              size: 20,
                              color: user != null
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF006884),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user != null ? 'Log Out' : 'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: user != null
                                    ? const Color(0xFFDC2626)
                                    : const Color(0xFF006884),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String initialLetter) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF006884),
            Color(0xFF009CBF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initialLetter,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEAECF0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Soft Teal/Blue Circle Icon Badge
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEBF5FF),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF006884),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Directly launches Google Play Store / App Store page for rating.
  Future<void> _openPlayStore() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.openStoreListing();
        return;
      }
    } catch (e) {
      debugPrint('InAppReview openStoreListing error: $e');
    }

    // Direct Google Play Store fallback URL
    final Uri playStoreUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.ably.tarot_card_reading',
    );
    try {
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('url_launcher error: $e');
    }
  }
}
