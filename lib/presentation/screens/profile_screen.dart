import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../state/providers/auth_provider.dart';

/// User Profile Detail screen integrated with Firebase Auth state.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const backgroundColor = Color(0xFFF7F7FD);
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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Back Button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF006884),
                        size: 22,
                      ),
                    ),
                  ),

                  // Header Title Centered
                  const Expanded(
                    child: Text(
                      'Divine Readings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF006884),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),

                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // User Profile Picture Header
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE2E8F0),
                          border: Border.all(
                            color: const Color(0xFFE5F1FF),
                            width: 4,
                          ),
                        ),
                        child: ClipOval(
                          child: user?.photoURL != null &&
                                  user!.photoURL!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: user.photoURL!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                  placeholder: (context, url) =>
                                      const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF006884),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              : Icon(
                                  user?.isAnonymous == true
                                      ? Icons.person_outline
                                      : Icons.person,
                                  size: 60,
                                  color: Colors.grey.shade600,
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // User Name
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // User Email
                    Text(
                      emailText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF667085),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Menu Option Cards
                    _buildOptionCard(
                      icon: Icons.person_outline_rounded,
                      title: 'Personal Information',
                      onTap: () {
                        Navigator.of(context).pushNamed('/language');
                      },
                    ),
                    const SizedBox(height: 10),

                    _buildOptionCard(
                      icon: Icons.favorite_border_rounded,
                      title: 'Reading Preferences',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),

                    _buildOptionCard(
                      icon: Icons.star_outline_rounded,
                      title: 'Subscription Plan',
                      subtitle: 'Premium',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),

                    _buildOptionCard(
                      icon: Icons.link_rounded,
                      title: 'Linked Accounts',
                      onTap: () {},
                    ),

                    const SizedBox(height: 28),

                    // Log Out / Sign In Button
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
                              ? const Color(0xFFFFF0F0)
                              : const Color(0xFFEBF5FF),
                          foregroundColor: user != null
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF006884),
                          elevation: 0,
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
                              color: user != null
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF006884),
                              size: 20,
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

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF2F4F7),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Soft Blue Circle Icon Badge
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEBF5FF),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0088B2),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF101828),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0088B2),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Right Chevron Arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFD0D5DD),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
