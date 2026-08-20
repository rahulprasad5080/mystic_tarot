import 'package:flutter/material.dart';

/// Premium, sleek Terms & Conditions Screen for Ably Tarot Card Reading.
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
                    'Terms & Conditions',
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

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner Card
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
                                Icons.description_outlined,
                                color: Color(0xFF006884),
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Terms of Service',
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
                            'Please read these terms and conditions carefully before using Ably Tarot Card Reading.',
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

                    // Section 1: Acceptance of Terms
                    _buildSectionCard(
                      icon: Icons.gavel_rounded,
                      title: '1. Acceptance of Terms',
                      content:
                          'By downloading, accessing, or using Ably Tarot Card Reading, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree, please discontinue using the application.',
                    ),

                    const SizedBox(height: 16),

                    // Section 2: Entertainment Purpose Disclaimer
                    _buildSectionCard(
                      icon: Icons.auto_awesome_rounded,
                      title: '2. Entertainment Purpose Disclaimer',
                      content:
                          'Ably Tarot Card Reading is designed exclusively for spiritual insight, self-reflection, and entertainment purposes.\n\n'
                          '• Readings do NOT constitute professional medical, legal, financial, or psychological advice.\n'
                          '• Always seek the advice of qualified professionals for critical life decisions.',
                    ),

                    const SizedBox(height: 16),

                    // Section 3: Intellectual Property
                    _buildSectionCard(
                      icon: Icons.copyright_rounded,
                      title: '3. Intellectual Property',
                      content:
                          'All original app graphics, tarot card illustrations, text content, design templates, and software code are the intellectual property of Ably Tarot and protected by copyright laws.',
                    ),

                    const SizedBox(height: 16),

                    // Section 4: User Responsibilities
                    _buildSectionCard(
                      icon: Icons.person_outline_rounded,
                      title: '4. User Conduct',
                      content:
                          'Users agree not to tamper with app code, reverse-engineer system APIs, or attempt unauthorized access to our cloud services.',
                    ),

                    const SizedBox(height: 16),

                    // Section 5: Modifications & Termination
                    _buildSectionCard(
                      icon: Icons.update_rounded,
                      title: '5. Changes to Terms',
                      content:
                          'We reserve the right to update these terms at any time. Continued use of the app following updates signifies your acceptance of the revised terms.',
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
