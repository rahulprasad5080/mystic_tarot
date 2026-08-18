import 'package:flutter/material.dart';

/// Screen displaying saved readings (empty state matching the UI mockup design).
class SavedReadingsScreen extends StatefulWidget {
  const SavedReadingsScreen({super.key});

  @override
  State<SavedReadingsScreen> createState() => _SavedReadingsScreenState();
}

class _SavedReadingsScreenState extends State<SavedReadingsScreen> {
  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF7F7FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language Globe Icon Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/language');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBF5FF),
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
                    'Divine Readings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006884),
                      letterSpacing: -0.3,
                    ),
                  ),

                  // User Avatar Icon Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFE0E0E0),
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          size: 22,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Empty State Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // Illustration Graphic
                    _buildIllustrationGraphic(),

                    const SizedBox(height: 28),

                    // Headline Title
                    const Text(
                      'Your Saved Guidance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle Body Text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Readings you save will appear here. Revisit your past readings anytime for continued reflection and wisdom.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF667085),
                          height: 1.45,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Primary Action Button: "Explore Readings"
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Tab switching to Home can be done by popping or handled via main screen
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006884),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Explore Readings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom illustration widget representing the fanned tarot cards and crystal ball graphic.
  Widget _buildIllustrationGraphic() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF4F9FF),
            Color(0xFFE8F3FF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006884).withValues(alpha: 0.05),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Sparkles Glow
          Positioned(
            top: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.auto_awesome, size: 16, color: Color(0xFF90CAF9)),
                SizedBox(width: 140),
                Icon(Icons.auto_awesome, size: 14, color: Color(0xFF90CAF9)),
              ],
            ),
          ),

          // Fanned Tarot Cards Stack
          Positioned(
            top: 45,
            child: SizedBox(
              width: 240,
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Left Card
                  Transform.rotate(
                    angle: -0.35,
                    child: _buildMiniCard(Icons.wb_twilight),
                  ),
                  // Inner Left Card
                  Transform.rotate(
                    angle: -0.18,
                    child: _buildMiniCard(Icons.brightness_7),
                  ),
                  // Center Card
                  _buildMiniCard(Icons.auto_awesome),
                  // Inner Right Card
                  Transform.rotate(
                    angle: 0.18,
                    child: _buildMiniCard(Icons.star),
                  ),
                  // Outer Right Card
                  Transform.rotate(
                    angle: 0.35,
                    child: _buildMiniCard(Icons.nightlight_round),
                  ),
                ],
              ),
            ),
          ),

          // Crystal Ball Graphic at bottom center
          Positioned(
            bottom: 25,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFE1F5FE),
                        Color(0xFF81D4FA),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0088B2).withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lens_blur_rounded,
                    color: Color(0xFF006884),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 4),
                // Cloud base
                Container(
                  width: 70,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(IconData icon) {
    return Container(
      width: 52,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF90CAF9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 22,
          color: const Color(0xFF0088B2),
        ),
      ),
    );
  }
}
