import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/reading_types.dart';
import '../../core/l10n/generated/app_localizations.dart';

/// Card selection screen matching the exact UI design mockup:
/// - Light celestial background with soft light blue cards.
/// - 3 columns grid of 22 Major Arcana cards with circular star emblem & Roman numerals.
/// - Top action row with "Focus on your question and choose a card from the Major Arcana" and "Random Pick" pill button.
/// - Reveal Reading action button.
class CardSelectScreen extends StatefulWidget {
  final ReadingType readingType;

  const CardSelectScreen({super.key, required this.readingType});

  @override
  State<CardSelectScreen> createState() => _CardSelectScreenState();
}

class _CardSelectScreenState extends State<CardSelectScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedCard;
  late AnimationController _gridIntroController;

  static const List<String> _majorArcana = [
    'The Fool',
    'The Magician',
    'The High Priestess',
    'The Empress',
    'The Emperor',
    'The Hierophant',
    'The Lovers',
    'The Chariot',
    'Strength',
    'The Hermit',
    'Wheel of Fortune',
    'Justice',
    'The Hanged Man',
    'Death',
    'Temperance',
    'The Devil',
    'The Tower',
    'The Star',
    'The Moon',
    'The Sun',
    'Judgement',
    'The World',
  ];

  @override
  void initState() {
    super.initState();
    _gridIntroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _gridIntroController.dispose();
    super.dispose();
  }

  void _pickRandomCard() {
    HapticFeedback.mediumImpact();
    final randomCard = math.Random().nextInt(22) + 1;
    setState(() {
      _selectedCard = randomCard;
    });
  }

  String _toRoman(int number) {
    const romanMap = [
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI',
      'XII',
      'XIII',
      'XIV',
      'XV',
      'XVI',
      'XVII',
      'XVIII',
      'XIX',
      'XX',
      'XXI',
      'XXII',
    ];
    if (number >= 1 && number <= 22) {
      return romanMap[number - 1];
    }
    return '$number';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const backgroundColor = Color(0xFFF7F7FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
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
                        color: Color(0xFF006884),
                        size: 22,
                      ),
                    ),
                  ),

                  // Header Title
                  const Text(
                    'Select Card',
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

            // Content Body
            Expanded(
              child: Column(
                children: [
                  // Subtitle & Random Pick Pill Button Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side instruction text matching screenshot exact wording
                        const Expanded(
                          child: Text(
                            'Focus on your question and choose a card from the Major Arcana',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475467),
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Random Pick Pill Button matching exact mockup
                        InkWell(
                          onTap: _pickRandomCard,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFEAECF0),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.auto_awesome_outlined,
                                  size: 15,
                                  color: Color(0xFF344054),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Random Pick',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF344054),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Card Grid (3 Columns)
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: 22,
                      itemBuilder: (context, index) {
                        final cardNum = index + 1;
                        final isSelected = _selectedCard == cardNum;

                        return AnimatedBuilder(
                          animation: _gridIntroController,
                          builder: (context, child) {
                            final delay = index * 0.025;
                            final start = delay.clamp(0.0, 0.6);
                            final end = (start + 0.4).clamp(0.0, 1.0);
                            final anim = CurvedAnimation(
                              parent: _gridIntroController,
                              curve: Interval(
                                start,
                                end,
                                curve: Curves.easeOutCubic,
                              ),
                            );

                            return FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            );
                          },
                          child: _TarotCard3DTile(
                            cardNum: cardNum,
                            cardName: _majorArcana[index],
                            romanNumeral: _toRoman(cardNum),
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedCard = cardNum;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Reveal Reading Button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _selectedCard != null ? 1.0 : 0.5,
                        child: ElevatedButton(
                          onPressed: _selectedCard != null
                              ? () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.of(context).pushReplacementNamed(
                                    '/reading-detail',
                                    arguments: {
                                      'readingType': widget.readingType,
                                      'cardImage': _selectedCard.toString(),
                                    },
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006884),
                            foregroundColor: Colors.white,
                            elevation: _selectedCard != null ? 2 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.revealReading,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
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

/// Card Tile Component matching exact visual design of screenshot:
/// Soft light blue card, rounded corners, center circular star badge, Roman numeral.
class _TarotCard3DTile extends StatefulWidget {
  final int cardNum;
  final String cardName;
  final String romanNumeral;
  final bool isSelected;
  final VoidCallback onTap;

  const _TarotCard3DTile({
    required this.cardNum,
    required this.cardName,
    required this.romanNumeral,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TarotCard3DTile> createState() => _TarotCard3DTileState();
}

class _TarotCard3DTileState extends State<_TarotCard3DTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOutCubic,
      ),
    );

    if (widget.isSelected) {
      _flipController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _TarotCard3DTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _flipController.forward(from: 0.0);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _flipController.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value;
          final isBack = angle < (math.pi / 2);

          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isBack
                ? _buildCardBack()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildCardFront(),
                  ),
          );
        },
      ),
    );
  }

  /// Card Visual matching mockup screenshot (Light blue, circular star badge, Roman numeral)
  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBF5FE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isSelected
              ? const Color(0xFF006884)
              : const Color(0xFFCBE3FB),
          width: widget.isSelected ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF006884,
            ).withValues(alpha: widget.isSelected ? 0.25 : 0.03),
            blurRadius: widget.isSelected ? 10 : 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center Content: Star Badge & Roman Numeral
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Soft Blue Star Badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFBCE0FD).withValues(alpha: 0.7),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Color(0xFF509CEE),
                    size: 22,
                  ),
                ),
                const SizedBox(height: 8),

                // Roman Numeral Text
                Text(
                  widget.romanNumeral,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B9FE8),
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          // Selected Checkmark Badge (Top-Right)
          if (widget.isSelected)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF006884),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
        ],
      ),
    );
  }

  /// Selected / Flipped Card Front Visual
  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF006884),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006884).withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Checkmark badge
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF006884),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEBF5FF),
                    ),
                    child: Center(
                      child: Text(
                        widget.romanNumeral,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF006884),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.cardName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
