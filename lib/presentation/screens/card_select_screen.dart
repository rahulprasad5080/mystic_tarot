import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/reading_types.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../widgets/mystical_background.dart';
import '../widgets/gradient_header.dart';

/// Card selection screen for readings that require a card_image (1-22).
/// Displays a grid of 22 Major Arcana cards with 3D perspective flip animations
/// and haptic touch feedback.
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

  // Major Arcana names for display
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
      duration: const Duration(milliseconds: 900),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: MysticalBackground(
        child: Column(
          children: [
            // Gradient header
            GradientHeader(
              title: l10n.selectCard,
              onBack: () => Navigator.of(context).pop(),
            ),

            // Content below the header
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // Subtitle & Random Draw Action Button Row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.selectCardDesc,
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Random Quick Pick Button
                          InkWell(
                            onTap: _pickRandomCard,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF5FF),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFC2E0FF),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 14,
                                    color: Color(0xFF006884),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Random Pick',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF006884),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Card grid with 3D Flip Items
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
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
                              final delay = index * 0.035;
                              final start = delay.clamp(0.0, 0.7);
                              final end = (start + 0.3).clamp(0.0, 1.0);
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
                                    begin: const Offset(0, 0.25),
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
                        height: 56,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _selectedCard != null ? 1.0 : 0.4,
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
                              backgroundColor: AppColors.accentBlue,
                              foregroundColor: AppColors.onAccent,
                              elevation: _selectedCard != null ? 4 : 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.revealReading,
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.onAccent,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
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
            ),
          ],
        ),
      ),
    );
  }

  String _toRoman(int num) {
    const values = [10, 9, 5, 4, 1];
    const symbols = ['X', 'IX', 'V', 'IV', 'I'];
    var result = '';
    var remaining = num;
    for (var i = 0; i < values.length; i++) {
      while (remaining >= values[i]) {
        result += symbols[i];
        remaining -= values[i];
      }
    }
    return result;
  }
}

/// Interactive 3D Perspective Card Tile supporting smooth Y-axis 3D Flip Animation,
/// mystical deck back visual, card face visual, and glowing aura.
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
      duration: const Duration(milliseconds: 550),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOutBack,
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

          // Perspective transformation matrix for 3D flip effect
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Perspective intensity
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: isBack
                ? _buildCardBack()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi), // Reverse mirror text for front face
                    child: _buildCardFront(),
                  ),
          );
        },
      ),
    );
  }

  /// Unflipped Mystical Card Back Visual
  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF0284C7),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Inner Golden/Cyan Decorative Frame Line
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFBAE6FD).withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
              ),
            ),
          ),

          // Center Mystical Emblem Icon
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    border: Border.all(
                      color: const Color(0xFF7DD3FC).withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF7DD3FC),
                    size: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.romanNumeral,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Flipped Selected Mystical Card Front Visual
  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE0F2FE),
            Colors.white,
            Color(0xFFF0F9FF),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF006884),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006884).withValues(alpha: 0.35),
            blurRadius: 14,
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Selected Checkmark Badge (Top-Right Corner)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF006884),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),

          // Card Content Details
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Roman Numeral Glowing Badge
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEBF5FF),
                      border: Border.all(
                        color: const Color(0xFF006884),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.romanNumeral,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF006884),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Card Title
                  Text(
                    widget.cardName,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101828),
                      height: 1.2,
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
