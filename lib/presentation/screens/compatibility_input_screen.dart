import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/reading_types.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../widgets/mystical_background.dart';
import '../widgets/gradient_header.dart';
import '../widgets/glass_card.dart';

/// Screen to select two zodiac signs for Love Compatibility reading.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: MysticalBackground(
        child: Column(
          children: [
            // Gradient header
            GradientHeader(
              title: l10n.selectSigns,
              onBack: () => Navigator.of(context).pop(),
            ),

            // Content below the header
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        l10n.selectSignsDesc,
                        style: AppTextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pickers
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Sign 1 Picker
                            _buildSignPickerCard(
                              title: l10n.yourSign,
                              selectedSign: _sign1,
                              onSignSelected: (sign) =>
                                  setState(() => _sign1 = sign),
                            ),
                            const SizedBox(height: 20),

                            // Heart Divider Icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColors.categoryLove.withValues(alpha: 0.2),
                                border: Border.all(
                                  color: AppColors.categoryLove
                                      .withValues(alpha: 0.4),
                                ),
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: AppColors.categoryLove,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign 2 Picker
                            _buildSignPickerCard(
                              title: l10n.partnerSign,
                              selectedSign: _sign2,
                              onSignSelected: (sign) =>
                                  setState(() => _sign2 = sign),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Calculate Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              '/reading-detail',
                              arguments: {
                                'readingType': widget.readingType,
                                'sign1': _sign1,
                                'sign2': _sign2,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentBlue,
                            foregroundColor: AppColors.onAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.calculateCompatibility,
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.onAccent,
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

  Widget _buildSignPickerCard({
    required String title,
    required String selectedSign,
    required ValueChanged<String> onSignSelected,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.accentBlue,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.zodiacSigns.length,
              itemBuilder: (context, index) {
                final sign = AppConstants.zodiacSigns[index];
                final isSelected = sign == selectedSign;
                final emoji = AppConstants.zodiacEmojis[sign] ?? '✨';

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => onSignSelected(sign),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? AppColors.primaryBlue.withValues(alpha: 0.3)
                            : AppColors.backgroundCardLight
                                .withValues(alpha: 0.5),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accentBlue
                              : AppColors.primaryBlue.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sign,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isSelected
                                  ? AppColors.accentBlue
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
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
