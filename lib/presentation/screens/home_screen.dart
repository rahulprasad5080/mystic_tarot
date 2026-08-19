import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/reading_types.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../state/providers/auth_provider.dart';
import '../../data/services/ad_service.dart';
import '../widgets/native_ad_widget.dart';

/// Main home screen matching the exact design of the Divine Readings app mockup.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  void _onReadingTap(ReadingType reading) {
    AdService.instance.showInterstitialAd(
      onAdDismissed: () {
        if (!mounted) return;
        if (reading.inputType == ReadingInputType.twoSigns) {
          Navigator.of(context).pushNamed(
            '/compatibility-input',
            arguments: reading,
          );
        } else {
          Navigator.of(context).pushNamed(
            '/reading-input',
            arguments: reading,
          );
        }
      },
    );
  }

  /// Ordered list of exactly 20 readings requested by client
  static const List<String> _clientReadingOrder = [
    'yes_or_no_tarot',
    'in_depth_love',
    'divine_angel',
    'daily_tarot',
    'dream_come_true',
    'fortune_cookie',
    'past_lives_connection',
    'flirt_love',
    'erotic_love',
    'egyptian_prediction',
    'ex_flame',
    'made_for_each_other',
    'power_life',
    'know_your_friend',
    'career_daily',
    'heartbreak',
    'love_triangle',
    'coffee_cup',
    'divine_magic',
    'love_compatibility',
  ];

  /// Get list of exactly the 20 reading types in exact order requested by client
  List<ReadingType> get _homeReadings {
    final list = <ReadingType>[];
    for (final id in _clientReadingOrder) {
      final item = ReadingTypes.byId(id);
      if (item != null) list.add(item);
    }
    return list;
  }

  /// Map exact client names for each of the 20 reading types
  String _getReadingName(AppLocalizations? l10n, ReadingType reading) {
    final map = <String, String>{
      'yes_or_no_tarot': 'Yes OR No Tarot',
      'in_depth_love': 'In-Depth Love Reading',
      'divine_angel': 'Divine Angel Reading',
      'daily_tarot': 'Daily Tarot',
      'dream_come_true': 'Dream Come True Reading',
      'fortune_cookie': 'Which Animal Are You Reading',
      'past_lives_connection': 'Past-Present-Future Reading',
      'flirt_love': 'Flirt Love Reading',
      'erotic_love': 'Erotic Love Reading',
      'egyptian_prediction': 'Egyptian Prediction',
      'ex_flame': 'Ex-Flame Reading',
      'made_for_each_other': 'Made For Each Other Or Not Reading',
      'power_life': 'Power Life Reading',
      'know_your_friend': 'Know Your Friend Reading',
      'career_daily': 'Career Daily Reading',
      'heartbreak': 'Heartbreak Reading',
      'love_triangle': 'Love Triangle Reading',
      'coffee_cup': 'Wisdom Reading',
      'divine_magic': 'Divine Magic Reading',
      'love_compatibility': 'Past Lives Connection Reading',
    };
    return map[reading.id] ?? reading.id;
  }

  String _getReadingDesc(AppLocalizations? l10n, ReadingType reading) {
    final map = <String, String>{
      'yes_or_no_tarot': 'Quick answers for immediate clarity',
      'in_depth_love': 'Explore the depths of your relationship',
      'divine_angel': 'Receive guidance from higher realm',
      'daily_tarot': 'Your guidance for the day ahead',
      'dream_come_true': 'Manifesting your deepest desires',
      'fortune_cookie': 'Discover your spirit guidance',
      'past_lives_connection': "Understand your timeline's flow",
      'flirt_love': 'Playful insights into new romance',
      'erotic_love': 'Intimate and passionate energy',
      'egyptian_prediction': 'Ancient wisdom for modern life',
      'ex_flame': 'Clarity on past relationships',
      'made_for_each_other': 'Evaluate core relationship bond',
      'power_life': 'Unlock your true potential',
      'know_your_friend': 'Insights into platonic bonds',
      'career_daily': 'Navigate professional growth',
      'heartbreak': 'Healing and moving forward',
      'love_triangle': 'Untangle complex emotions',
      'coffee_cup': 'Deep insights for spiritual journey',
      'divine_magic': 'Tap into mystical energies',
      'love_compatibility': 'Uncover karmic ties & harmony',
    };
    return map[reading.id] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const backgroundColor = Color(0xFFF7F7FD);
    final user = ref.watch(currentUserProvider);

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
                    'Ably Tarot',
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
                        child: user?.photoURL != null && user!.photoURL!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: user.photoURL!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 22,
                                  color: Colors.grey.shade700,
                                ),
                              )
                            : Icon(
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

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Greeting Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Good Morning ✨',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF101828),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Discover your divine guidance',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Featured Blue Banner Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 18.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE3F2FF),
                              Color(0xFFD6EBFF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFC2E0FF),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Your answers are closer than you\nthink.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Choose a reading to begin your journey.',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Native Ad Unit
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: NativeAdWidget(),
                    ),

                    const SizedBox(height: 24),

                    // Section Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Choose Your Reading',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF101828),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // List of 20 Reading Types matching the exact screenshot design
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _homeReadings.length,
                      itemBuilder: (context, index) {
                        final reading = _homeReadings[index];
                        final title = _getReadingName(l10n, reading);
                        final desc = _getReadingDesc(l10n, reading);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: () => _onReadingTap(reading),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 12.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFF2F4F7),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Soft Blue Circular Icon Container
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFEBF5FF),
                                    ),
                                    child: Icon(
                                      reading.icon,
                                      color: const Color(0xFF0088B2),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Reading Title & Description
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF101828),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          desc,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF667085),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right Chevron Icon
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Color(0xFFD0D5DD),
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

