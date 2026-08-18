import 'package:flutter/material.dart';
import '../../core/constants/reading_types.dart';

/// Daily Tarot Screen designed to match the user mockup screenshot exactly.
/// Features a top header, subtitle prompt, central interactive card reveal,
/// and a horizontal list of previous daily cards.
class DailyTarotScreen extends StatefulWidget {
  const DailyTarotScreen({super.key});

  @override
  State<DailyTarotScreen> createState() => _DailyTarotScreenState();
}

class _DailyTarotScreenState extends State<DailyTarotScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  bool _isFlipping = false;

  // Mock previous daily readings matching the exact cards shown in screenshot
  final List<_PreviousDailyCardItem> _previousCards = const [
    _PreviousDailyCardItem(
      label: 'YESTERDAY',
      cardTitle: 'THE SUN',
      cardSubtitle: 'Illumination, success, vitality, joy',
      badgeNum: 'XIX',
      primaryColor: Color(0xFFFDE68A),
      secondaryColor: Color(0xFFFFFBEB),
      accentColor: Color(0xFFD97706),
      icon: Icons.wb_sunny_rounded,
    ),
    _PreviousDailyCardItem(
      label: 'OCT 12',
      cardTitle: 'THE STAR',
      cardSubtitle: 'Hope, faith, renewal & inspiration',
      badgeNum: 'XVII',
      primaryColor: Color(0xFFBAE6FD),
      secondaryColor: Color(0xFFF0F9FF),
      accentColor: Color(0xFF0284C7),
      icon: Icons.auto_awesome_rounded,
    ),
    _PreviousDailyCardItem(
      label: 'OCT 11',
      cardTitle: 'THE MOON',
      cardSubtitle: 'Intuition, dreams, subconscious',
      badgeNum: 'XVIII',
      primaryColor: Color(0xFFE9D5FF),
      secondaryColor: Color(0xFFFAF5FF),
      accentColor: Color(0xFF7E22CE),
      icon: Icons.nights_stay_rounded,
    ),
    _PreviousDailyCardItem(
      label: 'OCT 10',
      cardTitle: 'ACE OF CUPS',
      cardSubtitle: 'New feelings, compassion, love',
      badgeNum: 'I',
      primaryColor: Color(0xFFBBF7D0),
      secondaryColor: Color(0xFFF0FDF4),
      accentColor: Color(0xFF15803D),
      icon: Icons.water_drop_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.92), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.05), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 20),
    ]).animate(_flipController);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _onCardTap() async {
    if (_isFlipping) return;
    setState(() => _isFlipping = true);

    await _flipController.forward(from: 0);

    if (!mounted) return;

    // Navigate to Reading Detail Screen for Daily Tarot
    final dailyTarotType = ReadingTypes.byId('daily_tarot') ??
        const ReadingType(
          id: 'daily_tarot',
          nameKey: 'readingDailyTarot',
          descriptionKey: 'readingDailyTarotDesc',
          endpoint: '/api/v2/daily-tarot',
          icon: Icons.today_rounded,
          accentColor: Color(0xFF006884),
          category: ReadingCategory.tarot,
        );

    Navigator.of(context).pushNamed(
      '/reading-detail',
      arguments: dailyTarotType,
    ).then((_) {
      if (mounted) {
        _flipController.reset();
        setState(() => _isFlipping = false);
      }
    });
  }

  void _openPreviousCard(_PreviousDailyCardItem cardItem) {
    final dailyTarotType = ReadingTypes.byId('daily_tarot') ??
        const ReadingType(
          id: 'daily_tarot',
          nameKey: 'readingDailyTarot',
          descriptionKey: 'readingDailyTarotDesc',
          endpoint: '/api/v2/daily-tarot',
          icon: Icons.today_rounded,
          accentColor: Color(0xFF006884),
          category: ReadingCategory.tarot,
        );

    Navigator.of(context).pushNamed(
      '/reading-detail',
      arguments: dailyTarotType,
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF8F9FE);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Arrow Button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
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
                    'Daily Tarot',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006884),
                      letterSpacing: -0.3,
                    ),
                  ),

                  // Profile Avatar Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBF5FF),
                      ),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFD0E3F5),
                        child: Icon(
                          Icons.person,
                          size: 22,
                          color: Color(0xFF006884),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Main Scrollable Body ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Subtitle Tagline
                      const Text(
                        'Seek clarity for the day ahead',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5A6E85),
                          letterSpacing: -0.2,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Central Main Tarot Card ──
                      GestureDetector(
                        onTap: _onCardTap,
                        child: AnimatedBuilder(
                          animation: _flipController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(_flipAnimation.value * 3.14159),
                                alignment: Alignment.center,
                                child: _buildMainCard(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Guidance prompt text below card
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Tap the card to reveal your guidance for today.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF475569),
                            height: 1.35,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Previous Daily Cards Section Header ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Previous Daily Cards',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/saved');
                            },
                            child: const Text(
                              'VIEW ALL',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF006884),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ── Horizontal List of Previous Cards ──
                      SizedBox(
                        height: 195,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _previousCards.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final card = _previousCards[index];
                            return _buildPreviousCardItem(card);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the large central unrevealed card matching the screenshot mockup
  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 320,
        minHeight: 410,
        maxHeight: 430,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF3F6FF),
            Color(0xFFE9EFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE2E7FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.06),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 10,
            spreadRadius: -2,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Four Corner Sparkle Sun Icons ──
          Positioned(
            top: 20,
            left: 20,
            child: _buildCornerSparkle(),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: _buildCornerSparkle(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _buildCornerSparkle(),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _buildCornerSparkle(),
          ),

          // ── Center Circular Sparkle Badge ──
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEFF5FF),
              border: Border.all(
                color: const Color(0xFFD6E4FF),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                  blurRadius: 16,
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
                    size: 42,
                    color: Color(0xFF38BDF8),
                  ),
                  Icon(
                    Icons.auto_awesome,
                    size: 26,
                    color: Color(0xFF0284C7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Draws corner sparkle sun symbol matching the reference mockup
  Widget _buildCornerSparkle() {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: const Icon(
        Icons.wb_sunny_outlined,
        size: 20,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  /// Builds a thumbnail item for the "Previous Daily Cards" horizontal bar
  Widget _buildPreviousCardItem(_PreviousDailyCardItem card) {
    return GestureDetector(
      onTap: () => _openPreviousCard(card),
      child: Column(
        children: [
          // Card Thumbnail Container
          Container(
            width: 110,
            height: 155,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    card.secondaryColor,
                    card.primaryColor.withValues(alpha: 0.25),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: card.accentColor.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Roman numeral badge
                  Text(
                    card.badgeNum,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: card.accentColor,
                      letterSpacing: 1.0,
                    ),
                  ),

                  // Card Illustration Graphic Icon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.9),
                      boxShadow: [
                        BoxShadow(
                          color: card.accentColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      card.icon,
                      color: card.accentColor,
                      size: 26,
                    ),
                  ),

                  // Card Title inside Thumbnail
                  Text(
                    card.cardTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Uppercase Date / Day Label below thumbnail
          Text(
            card.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper data class for previous daily card history items
class _PreviousDailyCardItem {
  final String label;
  final String cardTitle;
  final String cardSubtitle;
  final String badgeNum;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final IconData icon;

  const _PreviousDailyCardItem({
    required this.label,
    required this.cardTitle,
    required this.cardSubtitle,
    required this.badgeNum,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.icon,
  });
}
