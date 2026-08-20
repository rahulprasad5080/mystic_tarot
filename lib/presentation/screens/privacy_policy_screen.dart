import 'package:flutter/material.dart';

/// Premium, sleek Privacy Policy Screen for Ably Tarot Card Reading.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                  // Header Title
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006884),
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Scrollable Policy Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Intro Banner Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFEBF5FF),
                            Color(0xFFD6EBFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFC2E0FF),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: Color(0xFF006884),
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Your Privacy Matters',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ably Tarot Card Reading is committed to maintaining the confidentiality, privacy, and security of your personal information.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Last Updated: August 2026',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF006884),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section 1: Information We Collect
                    _buildSectionCard(
                      icon: Icons.article_outlined,
                      title: '1. Information We Collect',
                      content:
                          '• Account Details: Name and email address when signing in via Google or registration.\n'
                          '• Reading Preferences: Saved profile names, dates of birth, and zodiac selection choices to personalize tarot insights.\n'
                          '• Technical & Usage Data: Anonymous device info, app performance logs, and AdMob advertising identifiers.',
                    ),

                    const SizedBox(height: 16),

                    // Section 2: How We Use Your Information
                    _buildSectionCard(
                      icon: Icons.auto_awesome_outlined,
                      title: '2. How We Use Information',
                      content:
                          '• To generate customized tarot readings and divine predictions.\n'
                          '• To store your saved profiles for quick reading input.\n'
                          '• To serve non-intrusive advertisements (Google AdMob) that keep our services accessible.\n'
                          '• To monitor app stability and fix technical issues.',
                    ),

                    const SizedBox(height: 16),

                    // Section 3: Third-Party Partners
                    _buildSectionCard(
                      icon: Icons.cloud_outlined,
                      title: '3. Third-Party Services',
                      content:
                          'We partner with reliable third-party services that operate under strict privacy compliance:\n'
                          '• Google AdMob: For displaying native & interstitial advertisements.\n'
                          '• Firebase (Google): For secure user authentication and analytics.\n'
                          '• DivineAPI: For tarot reading and astrological predictions engine.',
                    ),

                    const SizedBox(height: 16),

                    // Section 4: Data Security
                    _buildSectionCard(
                      icon: Icons.lock_outline_rounded,
                      title: '4. Data Security & Storage',
                      content:
                          'We employ industry-standard encryption protocols (SSL/TLS) to safeguard your data. We do NOT sell, trade, or rent your personal information to any third parties.',
                    ),

                    const SizedBox(height: 16),

                    // Section 5: Children's Privacy
                    _buildSectionCard(
                      icon: Icons.child_care_rounded,
                      title: '5. Children\'s Privacy',
                      content:
                          'Ably Tarot Card Reading does not knowingly collect personal data from individuals under 13 years of age. If you believe a minor has submitted personal information, please contact us immediately.',
                    ),

                    const SizedBox(height: 16),

                    // Section 6: Contact Us
                    _buildSectionCard(
                      icon: Icons.mark_email_read_outlined,
                      title: '6. Contact Us',
                      content:
                          'If you have any questions or concerns regarding this Privacy Policy, please reach out to us at:\n\n'
                          '📧 Email: support@ablytarot.com\n'
                          '🌐 Website: https://ablytarot.com',
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

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEAECF0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
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
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101828),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF475467),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
