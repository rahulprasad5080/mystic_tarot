import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/reading_types.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/services/ad_service.dart';

/// Zodiac sign color model for soft pastel circles and symbol colors
class ZodiacVisual {
  final String symbol;
  final Color bg;
  final Color symbolColor;

  const ZodiacVisual({
    required this.symbol,
    required this.bg,
    required this.symbolColor,
  });
}

/// Screen to select two zodiac signs for Love Compatibility & Past Lives Connection readings,
/// matching the exact design of the Zodiac selection mockup.
class CompatibilityInputScreen extends StatefulWidget {
  final ReadingType readingType;

  const CompatibilityInputScreen({super.key, required this.readingType});

  @override
  State<CompatibilityInputScreen> createState() =>
      _CompatibilityInputScreenState();
}

class _CompatibilityInputScreenState extends State<CompatibilityInputScreen> {
  String _sign1 = 'Aries';
  String _sign2 = 'Aries';

  static const Map<String, ZodiacVisual> _zodiacVisuals = {
    'Aries': ZodiacVisual(
      symbol: '♈',
      bg: Color(0xFFFFE4E6),
      symbolColor: Color(0xFFE11D48),
    ),
    'Taurus': ZodiacVisual(
      symbol: '♉',
      bg: Color(0xFFFFEDD5),
      symbolColor: Color(0xFFEA580C),
    ),
    'Gemini': ZodiacVisual(
      symbol: '♊',
      bg: Color(0xFFFEF08A),
      symbolColor: Color(0xFFCA8A04),
    ),
    'Cancer': ZodiacVisual(
      symbol: '♋',
      bg: Color(0xFFFEF9C3),
      symbolColor: Color(0xFFD97706),
    ),
    'Leo': ZodiacVisual(
      symbol: '♌',
      bg: Color(0xFFFDE68A),
      symbolColor: Color(0xFFB45309),
    ),
    'Virgo': ZodiacVisual(
      symbol: '♍',
      bg: Color(0xFFDCFCE7),
      symbolColor: Color(0xFF16A34A),
    ),
    'Libra': ZodiacVisual(
      symbol: '♎',
      bg: Color(0xFFCCFBF1),
      symbolColor: Color(0xFF0D9488),
    ),
    'Scorpio': ZodiacVisual(
      symbol: '♏',
      bg: Color(0xFFE0F2FE),
      symbolColor: Color(0xFF0284C7),
    ),
    'Sagittarius': ZodiacVisual(
      symbol: '♐',
      bg: Color(0xFFE0E7FF),
      symbolColor: Color(0xFF4F46E5),
    ),
    'Capricorn': ZodiacVisual(
      symbol: '♑',
      bg: Color(0xFFF3E8FF),
      symbolColor: Color(0xFF7E22CE),
    ),
    'Aquarius': ZodiacVisual(
      symbol: '♒',
      bg: Color(0xFFEBF5FF),
      symbolColor: Color(0xFF006884),
    ),
    'Pisces': ZodiacVisual(
      symbol: '♓',
      bg: Color(0xFFFCE7F3),
      symbolColor: Color(0xFFDB2777),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const backgroundColor = Color(0xFFEAF5FE);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar matching design
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
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
                        color: Color(0xFF101828),
                        size: 22,
                      ),
                    ),
                  ),

                  // Header Title uppercase
                  Text(
                    l10n?.selectSigns.toUpperCase() ?? 'SELECT ZODIAC SIGNS',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Main Body Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Instruction Subtitle matching exact wording from mockup
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          l10n?.selectSignsDesc ??
                              'Choose your sign and your partner\'s sign to reveal love compatibility',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF475467),
                            height: 1.35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // YOUR SIGN Card Container
                      _buildSignSectionCard(
                        title: (l10n?.yourSign ?? 'YOUR SIGN').toUpperCase(),
                        selectedSign: _sign1,
                        onSignSelected: (sign) => setState(() => _sign1 = sign),
                      ),

                      // Floating Pink Heart Badge Divider
                      Transform.translate(
                        offset: const Offset(0, 0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12.0),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFCE7F3),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFEC4899,
                                ).withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFEC4899),
                            size: 20,
                          ),
                        ),
                      ),

                      // PARTNER'S SIGN Card Container
                      _buildSignSectionCard(
                        title: (l10n?.partnerSign ?? 'PARTNER\'S SIGN')
                            .toUpperCase(),
                        selectedSign: _sign2,
                        onSignSelected: (sign) => setState(() => _sign2 = sign),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Calculate Action Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    AdService.instance.showInterstitialAd(
                      onAdDismissed: () {
                        if (!mounted) return;
                        Navigator.of(context).pushReplacementNamed(
                          '/reading-detail',
                          arguments: {
                            'readingType': widget.readingType,
                            'sign1': _sign1,
                            'sign2': _sign2,
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006884),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n?.calculateCompatibility ?? 'Calculate Compatibility',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignSectionCard({
    required String title,
    required String selectedSign,
    required ValueChanged<String> onSignSelected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2F4F7), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (YOUR SIGN / PARTNER'S SIGN)
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF006884),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),

          // Scrollable Zodiac Cards Row matching screenshot
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.zodiacSigns.length,
              itemBuilder: (context, index) {
                final sign = AppConstants.zodiacSigns[index];
                final isSelected = sign == selectedSign;
                final visual =
                    _zodiacVisuals[sign] ??
                    const ZodiacVisual(
                      symbol: '✨',
                      bg: Color(0xFFEBF5FF),
                      symbolColor: Color(0xFF006884),
                    );

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () => onSignSelected(sign),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 82,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF00A3E0)
                              : const Color(0xFFEAECF0),
                          width: isSelected ? 2.5 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00A3E0,
                                  ).withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Soft Pastel Circle Container with Astrological Symbol
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: visual.bg,
                            ),
                            child: Center(
                              child: Text(
                                visual.symbol,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: visual.symbolColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Zodiac Sign Label Text
                          Text(
                            sign,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF101828)
                                  : const Color(0xFF475467),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
