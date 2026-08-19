import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/reading_types.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/models/reading_result.dart';
import '../../data/models/dual_card_result.dart';
import '../../data/models/love_compatibility_result.dart';
import '../../data/models/coffee_cup_result.dart';
import '../../data/models/special_results.dart';
import '../../state/providers/reading_provider.dart';
import '../widgets/mystical_background.dart';
import '../widgets/gradient_header.dart';
import '../widgets/glass_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/ad_banner_widget.dart';

/// Generic reading detail screen — displays results from any reading type.
/// Accepts a ReadingType and optional params (cardImage, signs).
class ReadingDetailScreen extends ConsumerWidget {
  final ReadingType readingType;
  final String? cardImage;
  final String? sign1;
  final String? sign2;

  const ReadingDetailScreen({
    super.key,
    required this.readingType,
    this.cardImage,
    this.sign1,
    this.sign2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final params = ReadingParams(
      readingType: readingType,
      cardImage: cardImage,
      sign1: sign1,
      sign2: sign2,
    );

    final readingAsync = ref.watch(readingProvider(params));

    return Scaffold(
      body: MysticalBackground(
        child: Column(
          children: [
            // Gradient header
            GradientHeader(
              title: _getReadingTitle(l10n),
              onBack: () => Navigator.of(context).pop(),
            ),

            // Content
            Expanded(
              child: SafeArea(
                top: false,
                child: readingAsync.when(
                  loading: () => const LoadingShimmer(),
                  error: (error, _) => ErrorRetryWidget(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(readingProvider(params)),
                  ),
                  data: (response) {
                    if (!response.isSuccess) {
                      final message = response.isAuthError
                          ? 'Invalid or expired DivineAPI key.\nPlease update DIVINE_API_KEY in your .env file.'
                          : (response.message ?? l10n.errorGeneric);
                      return ErrorRetryWidget(
                        message: message,
                        onRetry: () => ref.invalidate(readingProvider(params)),
                      );
                    }

                    return _buildResult(context, response.data);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getReadingTitle(AppLocalizations l10n) {
    final map = {
      'readingYesOrNo': l10n.readingYesOrNo,
      'readingDailyTarot': l10n.readingDailyTarot,
      'readingFortuneCookie': l10n.readingFortuneCookie,
      'readingCoffeeCup': l10n.readingCoffeeCup,
      'readingCareerDaily': l10n.readingCareerDaily,
      'readingDivineAngel': l10n.readingDivineAngel,
      'readingDivineMagic': l10n.readingDivineMagic,
      'readingDreamComeTrue': l10n.readingDreamComeTrue,
      'readingEgyptian': l10n.readingEgyptian,
      'readingEroticLove': l10n.readingEroticLove,
      'readingExFlame': l10n.readingExFlame,
      'readingFlirtLove': l10n.readingFlirtLove,
      'readingHeartbreak': l10n.readingHeartbreak,
      'readingInDepthLove': l10n.readingInDepthLove,
      'readingKnowFriend': l10n.readingKnowFriend,
      'readingLoveCompat': l10n.readingLoveCompat,
      'readingLoveTriangle': l10n.readingLoveTriangle,
      'readingMadeForEachOther': l10n.readingMadeForEachOther,
      'readingPowerLife': l10n.readingPowerLife,
      'readingPastLives': l10n.readingPastLives,
    };
    return map[readingType.nameKey] ?? readingType.nameKey;
  }

  Widget _buildResult(BuildContext context, dynamic data) {
    if (data is ReadingResult) {
      return _buildReadingResult(context, data);
    } else if (data is DualCardResult) {
      return _buildDualCardResult(context, data);
    } else if (data is LoveCompatibilityResult) {
      return _buildCompatibilityResult(context, data);
    } else if (data is CoffeeCupResult) {
      return _buildCoffeeCupResult(context, data);
    } else if (data is LoveTriangleResult) {
      return _buildTriangleResult(context, data);
    } else if (data is FortuneCookieResult) {
      return _buildFortuneCookieResult(context, data);
    }

    return Center(
      child: Text('Unexpected result type', style: AppTextStyles.bodyMedium),
    );
  }

  // ─────────── Single Card Reading ───────────

  Widget _buildReadingResult(BuildContext context, ReadingResult data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Card image
          if (data.displayImage != null)
            _buildCardImage(data.displayImage!, height: 280),

          const SizedBox(height: 20),

          // Card name + Yes/No badge
          if (data.card != null)
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    readingType.icon,
                    color: readingType.accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      data.card!,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.accentBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (data.hasYesNo) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: data.yesNo == 'YES'
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.error.withValues(alpha: 0.2),
                        border: Border.all(
                          color: data.yesNo == 'YES'
                              ? AppColors.success
                              : AppColors.error,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        data.yesNo!,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: data.yesNo == 'YES'
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          if (data.category != null) ...[
            const SizedBox(height: 8),
            Text(data.category!, style: AppTextStyles.bodySmall),
          ],

          const SizedBox(height: 12),

          // Native/Banner Ad placed between card area and reading
          const AdBannerWidget(),

          const SizedBox(height: 12),

          // Reading text
          if (data.displayText.isNotEmpty)
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Text(
                data.displayText,
                style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
              ),
            ),

          // Additional sections (for daily tarot)
          if (data.love != null && data.love!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSection('Love', data.love!, Icons.favorite_rounded),
          ],
          if (data.finance != null && data.finance!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSection(
              'Finance',
              data.finance!,
              Icons.account_balance_rounded,
            ),
          ],
        ],
      ),
    );
  }

  // ─────────── Dual Card Reading ───────────

  Widget _buildDualCardResult(BuildContext context, DualCardResult data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Card images side by side
          Row(
            children: [
              if (data.card1Image != null)
                Expanded(
                  child: Column(
                    children: [
                      _buildCardImage(data.card1Image!, height: 200),
                      const SizedBox(height: 8),
                      Text(
                        data.card1 ?? '',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.accentBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 12),
              if (data.card2Image != null)
                Expanded(
                  child: Column(
                    children: [
                      _buildCardImage(data.card2Image!, height: 200),
                      const SizedBox(height: 8),
                      Text(
                        data.card2 ?? '',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.accentBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Text content
          if (data.displayText.isNotEmpty)
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Text(
                data.displayText,
                style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────── Love Compatibility ───────────

  Widget _buildCompatibilityResult(
    BuildContext context,
    LoveCompatibilityResult data,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Signs header
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.sign1 ?? '',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.accentBlue,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: AppColors.categoryLove,
                    size: 28,
                  ),
                ),
                Text(
                  data.sign2 ?? '',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.accentBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scores
          if (data.score != null)
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScore('Overall', data.score!.general ?? '-'),
                  _buildScore(
                    'Communication',
                    data.score!.communication ?? '-',
                  ),
                  _buildScore('Intimacy', data.score!.sex ?? '-'),
                ],
              ),
            ),
          const SizedBox(height: 16),

          if (data.overallCompatibility != null)
            _buildSection(
              'Overview',
              data.overallCompatibility!,
              Icons.auto_awesome_rounded,
            ),
          if (data.positiveAspects != null) ...[
            const SizedBox(height: 16),
            _buildSection(
              'Positive Aspects',
              data.positiveAspects!,
              Icons.thumb_up_rounded,
            ),
          ],
          if (data.negativeAspects != null) ...[
            const SizedBox(height: 16),
            _buildSection(
              'Challenges',
              data.negativeAspects!,
              Icons.warning_rounded,
            ),
          ],
          if (data.idealDate != null) ...[
            const SizedBox(height: 16),
            _buildSection('Ideal Date', data.idealDate!, Icons.event_rounded),
          ],
        ],
      ),
    );
  }

  // ─────────── Coffee Cup ───────────

  Widget _buildCoffeeCupResult(BuildContext context, CoffeeCupResult data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (data.presentTitle != null)
            _buildCoffeeCupSection(
              'Present',
              data.presentTitle!,
              data.presentContent ?? '',
              data.presentImage,
              Icons.radio_button_checked_rounded,
            ),
          if (data.nearFutureTitle != null) ...[
            const SizedBox(height: 16),
            _buildCoffeeCupSection(
              'Near Future',
              data.nearFutureTitle!,
              data.nearFutureContent ?? '',
              data.nearFutureImage,
              Icons.fast_forward_rounded,
            ),
          ],
          if (data.distantFutureTitle != null) ...[
            const SizedBox(height: 16),
            _buildCoffeeCupSection(
              'Distant Future',
              data.distantFutureTitle!,
              data.distantFutureContent ?? '',
              data.distantFutureImage,
              Icons.schedule_rounded,
            ),
          ],
        ],
      ),
    );
  }

  // ─────────── Love Triangle ───────────

  Widget _buildTriangleResult(BuildContext context, LoveTriangleResult data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 3 cards
          Row(
            children: [
              if (data.card1Image != null)
                Expanded(child: _buildCardImage(data.card1Image!, height: 150)),
              const SizedBox(width: 8),
              if (data.card2Image != null)
                Expanded(child: _buildCardImage(data.card2Image!, height: 150)),
              const SizedBox(width: 8),
              if (data.card3Image != null)
                Expanded(child: _buildCardImage(data.card3Image!, height: 150)),
            ],
          ),
          const SizedBox(height: 20),

          if (data.your != null)
            _buildSection('Your Perspective', data.your!, Icons.person_rounded),
          if (data.lover1 != null) ...[
            const SizedBox(height: 16),
            _buildSection('First Lover', data.lover1!, Icons.favorite_rounded),
          ],
          if (data.lover2 != null) ...[
            const SizedBox(height: 16),
            _buildSection(
              'Second Lover',
              data.lover2!,
              Icons.favorite_border_rounded,
            ),
          ],
        ],
      ),
    );
  }

  // ─────────── Fortune Cookie ───────────

  Widget _buildFortuneCookieResult(
    BuildContext context,
    FortuneCookieResult data,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          borderColor: AppColors.accentBlue.withValues(alpha: 0.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cookie_rounded,
                color: AppColors.accentBlue,
                size: 48,
              ),
              const SizedBox(height: 24),
              Text(
                data.result ?? '',
                style: AppTextStyles.bodyLarge.copyWith(
                  height: 1.8,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────── Helpers ───────────

  Widget _buildCardImage(String url, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: height,
          width: height * 0.65,
          decoration: BoxDecoration(
            color: AppColors.backgroundCardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.accentBlue,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: height * 0.65,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFBAE6FD), Color(0xFFE0F2FE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentBlue.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.accentBlue.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.accentBlue,
                  size: 32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'ABLY TAROT CARD READING',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.accentBlue,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentBlue, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.accentBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: AppTextStyles.bodyMedium.copyWith(height: 1.7)),
        ],
      ),
    );
  }

  Widget _buildScore(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.accentBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }

  Widget _buildCoffeeCupSection(
    String timeframe,
    String title,
    String content,
    String? imageUrl,
    IconData icon,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentBlue, size: 18),
              const SizedBox(width: 8),
              Text(
                timeframe,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.accentBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
