import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/reading_types.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../../state/providers/ai_provider.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/models/reading_result.dart';
import '../../data/models/dual_card_result.dart';
import '../../data/models/love_compatibility_result.dart';
import '../../data/models/coffee_cup_result.dart';
import '../../data/models/special_results.dart';
import '../../state/providers/reading_provider.dart';
import '../../state/providers/ai_provider.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/native_ad_widget.dart';

/// Generic reading detail screen — displays results from any reading type.
/// Uses a clean celestial theme matching the target design (with NO profile icon).
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
      backgroundColor: const Color(0xFFF4F8FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F7FF),
              Color(0xFFF8FAFC),
              Color(0xFFEBF5FE),
            ],
          ),
        ),
        child: Column(
          children: [
            // Clean Header Bar (Back button + Title + No Profile Icon)
            _buildAppBar(context, _getReadingTitle(l10n)),

            // Main Content Area
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

  /// App bar with back button on left, centered title, and EMPTY right side (NO profile icon).
  Widget _buildAppBar(BuildContext context, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: const Color(0xFF0E697E),
                iconSize: 24,
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0E697E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // NO profile icon on the right! (User explicitly requested omitting profile icon)
              const SizedBox(width: 48),
            ],
          ),
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
    } else if (data is PastPresentFutureResult) {
      return _buildPastPresentFutureResult(context, data);
    }

    return Center(
      child: Text('Unexpected result type', style: AppTextStyles.bodyMedium),
    );
  }

  // ─────────── Single Card Reading ───────────

  Widget _buildReadingResult(BuildContext context, ReadingResult data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // 1. Header Subtitle ("The Stars Have Spoken" or Card title)
          if (data.hasYesNo) ...[
            const Text(
              'The Stars Have Spoken',
              style: TextStyle(
                color: Color(0xFF334155),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
          ] else if (data.card != null) ...[
            Text(
              data.card!,
              style: const TextStyle(
                color: Color(0xFF0E697E),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            if (data.category != null)
              Text(
                data.category!,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 20),
          ],

          // 2. Card Presentation with Glow and Sparkle Icon
          if (data.displayImage != null) ...[
            _buildCardDisplay(data.displayImage!),
            const SizedBox(height: 28),
          ] else ...[
            _buildCardFallbackDisplay(),
            const SizedBox(height: 28),
          ],

          // Native Ad Widget (Placed between Card preview and Article content)
          const NativeAdWidget(),
          const SizedBox(height: 20),

          // 3. Divine Insight Box
          if (data.displayText.isNotEmpty)
            _buildDivineInsightCard(
              title: 'Divine Insight',
              content: data.displayText,
            ),

          // Additional Sections (Love, Finance, Career)
          if (data.love != null && data.love!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'Love Reading',
              content: data.love!,
              icon: Icons.favorite_border_rounded,
            ),
          ],
          if (data.finance != null && data.finance!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'Financial Insight',
              content: data.finance!,
              icon: Icons.account_balance_outlined,
            ),
          ],
          if (data.career != null && data.career!.isNotEmpty && data.displayText != data.career) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'Career Forecast',
              content: data.career!,
              icon: Icons.work_outline_rounded,
            ),
          ],

          const SizedBox(height: 20),

          // Ask AI Oracle for Deeper Insight Banner Button
          Consumer(
            builder: (context, ref, child) {
              final l10n = AppLocalizations.of(context)!;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.blueGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Ask AI Oracle for Deeper Insight ✨',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Get personalized AI interpretation tailored to your situation.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentBlue,
                          foregroundColor: AppColors.onAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.psychology_rounded, size: 18),
                        label: const Text(
                          'Analyze with Mystic AI 🔮',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          final cardName = data.card ?? '';
                          final text = data.displayText;
                          final title = _getReadingTitle(l10n);

                          // Set reading context in AI provider
                          ref.read(aiChatProvider.notifier).setReadingContext(
                                readingTitle: title,
                                readingPrediction: text,
                                cardName: cardName.isNotEmpty ? cardName : null,
                              );

                          // Navigate to AI Oracle with reading context
                          Navigator.of(context).pushNamed('/ai-oracle');
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // 4. Native Ad Widget (Placed at bottom below all reading content)
          const NativeAdWidget(),
        ],
      ),
    );
  }

  /// Builds the card container with soft cyan glow and bottom-right sparkle badge overlay.
  Widget _buildCardDisplay(
    String url, {
    double? width = 250,
    double height = 350,
    double padding = 12,
  }) {
    final innerRadius = padding > 8 ? 16.0 : (padding > 5 ? 12.0 : 8.0);
    final outerRadius = padding > 8 ? 24.0 : (padding > 5 ? 16.0 : 12.0);

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Outer Card Frame with Soft Blue Glow & Shadow
          Container(
            width: width,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(outerRadius),
              border: Border.all(
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.9),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                  blurRadius: padding > 8 ? 36 : 16,
                  spreadRadius: padding > 8 ? 2 : 1,
                  offset: Offset(0, padding > 8 ? 10 : 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: padding > 8 ? 16 : 8,
                  offset: Offset(0, padding > 8 ? 4 : 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerRadius),
              child: CachedNetworkImage(
                imageUrl: url,
                height: height,
                width: width != null ? (width - (padding * 2)) : null,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: height,
                  color: const Color(0xFFF1F5F9),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF38BDF8),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildCardFallbackInner(),
              ),
            ),
          ),

          // Bottom-Right Sparkle Overlay Icon
          Positioned(
            right: padding > 8 ? -6 : -4,
            bottom: padding > 8 ? -6 : -4,
            child: Container(
              padding: EdgeInsets.all(padding > 8 ? 6 : 4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                    blurRadius: padding > 8 ? 10 : 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_awesome,
                color: const Color(0xFF38BDF8),
                size: padding > 8 ? 20 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFallbackDisplay() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 250,
            height: 350,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                  blurRadius: 32,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildCardFallbackInner(),
            ),
          ),
          Positioned(
            right: -6,
            bottom: -6,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF38BDF8),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFallbackInner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0EA5E9).withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF0EA5E9),
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'DIVINE TAROT',
            style: TextStyle(
              color: Color(0xFF0E697E),
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Divine Insight card box (white background, border, header icon & title, centered text).
  Widget _buildDivineInsightCard({
    required String title,
    required String content,
    IconData icon = Icons.brightness_7_outlined,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF0EA5E9).withValues(alpha: 0.04),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Title Row with Icon (Dark Teal color matching design)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFF0E697E),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0E697E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Content Paragraph (Centered text with soft line height)
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 15,
              height: 1.65,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────── Dual Card Reading ───────────

  Widget _buildDualCardResult(BuildContext context, DualCardResult data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              if (data.card1Image != null)
                Expanded(
                  child: Column(
                    children: [
                      _buildCardDisplay(
                        data.card1Image!,
                        height: 220,
                        padding: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.card1 ?? '',
                        style: const TextStyle(
                          color: Color(0xFF0E697E),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 12),
              if (data.card2Image != null)
                Expanded(
                  child: Column(
                    children: [
                      _buildCardDisplay(
                        data.card2Image!,
                        height: 220,
                        padding: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.card2 ?? '',
                        style: const TextStyle(
                          color: Color(0xFF0E697E),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Native Ad Widget (Placed between Cards and Article content)
          const NativeAdWidget(),
          const SizedBox(height: 20),

          if (data.displayText.isNotEmpty)
            _buildDivineInsightCard(
              title: 'Divine Insight',
              content: data.displayText,
            ),
          const SizedBox(height: 24),
          const NativeAdWidget(),
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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.sign1 ?? '',
                  style: const TextStyle(
                    color: Color(0xFF0E697E),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
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
                  style: const TextStyle(
                    color: Color(0xFF0E697E),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (data.score != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
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

          // Native Ad Widget (Placed between Score card and Article content)
          const NativeAdWidget(),
          const SizedBox(height: 16),

          if (data.overallCompatibility != null)
            _buildDivineInsightCard(
              title: 'Overview',
              content: data.overallCompatibility!,
              icon: Icons.auto_awesome_rounded,
            ),
          if (data.positiveAspects != null) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'Positive Aspects',
              content: data.positiveAspects!,
              icon: Icons.thumb_up_rounded,
            ),
          ],
          if (data.negativeAspects != null) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'Challenges',
              content: data.negativeAspects!,
              icon: Icons.warning_rounded,
            ),
          ],
          if (data.idealDate != null) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'Ideal Date',
              content: data.idealDate!,
              icon: Icons.event_rounded,
            ),
          ],
          const SizedBox(height: 24),

          // AI Insight Button for Compatibility
          Consumer(
            builder: (context, ref, child) {
              final title = '${data.sign1 ?? 'Sign1'} & ${data.sign2 ?? 'Sign2'} Compatibility';
              final prediction = data.overallCompatibility ?? 'Love compatibility reading';
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.blueGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Ask AI Oracle for Deeper Insight ✨',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Get personalized AI interpretation tailored to your situation.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentBlue,
                          foregroundColor: AppColors.onAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.psychology_rounded, size: 18),
                        label: const Text(
                          'Analyze with Mystic AI 🔮',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          ref.read(aiChatProvider.notifier).setReadingContext(
                                readingTitle: title,
                                readingPrediction: prediction,
                              );
                          Navigator.of(context).pushNamed('/ai-oracle');
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),
          const NativeAdWidget(),
        ],
      ),
    );
  }

  // ─────────── Coffee Cup ───────────

  Widget _buildCoffeeCupResult(BuildContext context, CoffeeCupResult data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
          const SizedBox(height: 24),
          const NativeAdWidget(),
        ],
      ),
    );
  }

  // ─────────── Love Triangle ───────────

  Widget _buildTriangleResult(BuildContext context, LoveTriangleResult data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              if (data.card1Image != null)
                Expanded(
                  child: Column(
                    children: [
                      _buildCardDisplay(
                        data.card1Image!,
                        height: 155,
                        padding: 5,
                      ),
                      if (data.card1 != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          data.card1!,
                          style: const TextStyle(
                            color: Color(0xFF0E697E),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(width: 6),
              if (data.card2Image != null)
                Expanded(
                  child: Column(
                    children: [
                      _buildCardDisplay(
                        data.card2Image!,
                        height: 155,
                        padding: 5,
                      ),
                      if (data.card2 != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          data.card2!,
                          style: const TextStyle(
                            color: Color(0xFF0E697E),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(width: 6),
              if (data.card3Image != null)
                Expanded(
                  child: Column(
                    children: [
                      _buildCardDisplay(
                        data.card3Image!,
                        height: 155,
                        padding: 5,
                      ),
                      if (data.card3 != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          data.card3!,
                          style: const TextStyle(
                            color: Color(0xFF0E697E),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Native Ad Widget (Placed between Cards and Article content)
          const NativeAdWidget(),
          const SizedBox(height: 20),

          if (data.your != null)
            _buildDivineInsightCard(
              title: 'Your Perspective',
              content: data.your!,
              icon: Icons.person_rounded,
            ),
          if (data.lover1 != null) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'First Lover',
              content: data.lover1!,
              icon: Icons.favorite_rounded,
            ),
          ],
          if (data.lover2 != null) ...[
            const SizedBox(height: 16),
            _buildDivineInsightCard(
              title: 'Second Lover',
              content: data.lover2!,
              icon: Icons.favorite_border_rounded,
            ),
          ],
          const SizedBox(height: 24),
          const NativeAdWidget(),
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
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cookie_rounded,
                color: Color(0xFF0E697E),
                size: 48,
              ),
              const SizedBox(height: 24),
              Text(
                data.result ?? '',
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontSize: 16,
                  height: 1.8,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const NativeAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScore(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF38BDF8),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
          ),
        ),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0E697E), size: 18),
              const SizedBox(width: 8),
              Text(
                timeframe,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
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
                      style: const TextStyle(
                        color: Color(0xFF0E697E),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 14,
                        height: 1.6,
                      ),
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

  // ─────────── Past Present Future ───────────

  Widget _buildPastPresentFutureResult(
    BuildContext context,
    PastPresentFutureResult data,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (data.past != null)
            _buildPastPresentFutureSection(
              'Past',
              data.past!,
              Icons.history_rounded,
            ),
          if (data.present != null) ...[
            const SizedBox(height: 20),
            _buildPastPresentFutureSection(
              'Present',
              data.present!,
              Icons.radio_button_checked_rounded,
            ),
          ],
          if (data.future != null) ...[
            const SizedBox(height: 20),
            _buildPastPresentFutureSection(
              'Future',
              data.future!,
              Icons.update_rounded,
            ),
          ],
          const SizedBox(height: 24),
          const NativeAdWidget(),
        ],
      ),
    );
  }

  Widget _buildPastPresentFutureSection(
    String period,
    PastPresentFutureCard cardData,
    IconData headerIcon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(headerIcon, color: const Color(0xFF0E697E), size: 22),
              const SizedBox(width: 8),
              Text(
                '$period - ${cardData.card ?? ''}',
                style: const TextStyle(
                  color: Color(0xFF0E697E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (cardData.image != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: cardData.image!,
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 220,
                    width: 150,
                    color: const Color(0xFFF1F5F9),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF38BDF8),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (cardData.image != null) const SizedBox(height: 16),
          if (cardData.summary != null && cardData.summary!.isNotEmpty)
            Text(
              cardData.summary!,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          if (cardData.advice != null && cardData.advice!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFF0284C7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cardData.advice!,
                      style: const TextStyle(
                        color: Color(0xFF0369A1),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

