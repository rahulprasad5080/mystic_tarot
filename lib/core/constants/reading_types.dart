import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'api_constants.dart';

/// Defines all 20 reading types with their metadata, icons, and API endpoint references.
enum ReadingCategory { tarot, love, life, spiritual }

/// Defines the type of input a reading requires before calling the API.
enum ReadingInputType {
  /// No user input needed — just call the API directly.
  none,

  /// Requires selecting a card_image (1–22 for Major Arcana).
  cardSelect,

  /// Requires selecting two zodiac signs for compatibility.
  twoSigns,

  /// Requires name + date of birth.
  nameDob,
}

class ReadingType {
  final String id;
  final String nameKey; // l10n key
  final String descriptionKey; // l10n key
  final String endpoint;
  final IconData icon;
  final Color accentColor;
  final ReadingCategory category;
  final ReadingInputType inputType;

  const ReadingType({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.endpoint,
    required this.icon,
    required this.accentColor,
    required this.category,
    this.inputType = ReadingInputType.none,
  });
}

/// All 20 primary reading types.
class ReadingTypes {
  ReadingTypes._();

  static const List<ReadingType> all = [
    // ── Tarot Readings ──
    ReadingType(
      id: 'yes_or_no_tarot',
      nameKey: 'readingYesOrNo',
      descriptionKey: 'readingYesOrNoDesc',
      endpoint: ApiConstants.yesOrNoTarot,
      icon: Icons.help_outline_rounded,
      accentColor: AppColors.categoryTarot,
      category: ReadingCategory.tarot,
    ),
    ReadingType(
      id: 'daily_tarot',
      nameKey: 'readingDailyTarot',
      descriptionKey: 'readingDailyTarotDesc',
      endpoint: ApiConstants.dailyTarot,
      icon: Icons.today_rounded,
      accentColor: AppColors.categoryTarot,
      category: ReadingCategory.tarot,
    ),
    ReadingType(
      id: 'fortune_cookie',
      nameKey: 'readingFortuneCookie',
      descriptionKey: 'readingFortuneCookieDesc',
      endpoint: ApiConstants.fortuneCookie,
      icon: Icons.cookie_rounded,
      accentColor: AppColors.accentBlue,
      category: ReadingCategory.tarot,
    ),
    ReadingType(
      id: 'coffee_cup',
      nameKey: 'readingCoffeeCup',
      descriptionKey: 'readingCoffeeCupDesc',
      endpoint: ApiConstants.coffeeCupReading,
      icon: Icons.coffee_rounded,
      accentColor: AppColors.accentBlueDark,
      category: ReadingCategory.spiritual,
    ),
    ReadingType(
      id: 'career_daily',
      nameKey: 'readingCareerDaily',
      descriptionKey: 'readingCareerDailyDesc',
      endpoint: ApiConstants.careerDailyReading,
      icon: Icons.work_outline_rounded,
      accentColor: AppColors.celestialBlue,
      category: ReadingCategory.life,
    ),
    ReadingType(
      id: 'divine_angel',
      nameKey: 'readingDivineAngel',
      descriptionKey: 'readingDivineAngelDesc',
      endpoint: ApiConstants.divineAngelReading,
      icon: Icons.brightness_7_rounded,
      accentColor: AppColors.categorySpirituality,
      category: ReadingCategory.spiritual,
    ),

    // ── Card-Select Readings ──
    ReadingType(
      id: 'divine_magic',
      nameKey: 'readingDivineMagic',
      descriptionKey: 'readingDivineMagicDesc',
      endpoint: ApiConstants.divineMagicReading,
      icon: Icons.auto_awesome_rounded,
      accentColor: AppColors.primaryBlue,
      category: ReadingCategory.spiritual,
      inputType: ReadingInputType.cardSelect,
    ),
    ReadingType(
      id: 'dream_come_true',
      nameKey: 'readingDreamComeTrue',
      descriptionKey: 'readingDreamComeTrueDesc',
      endpoint: ApiConstants.dreamComeTrueReading,
      icon: Icons.nights_stay_rounded,
      accentColor: AppColors.celestialBlue,
      category: ReadingCategory.life,
    ),
    ReadingType(
      id: 'egyptian_prediction',
      nameKey: 'readingEgyptian',
      descriptionKey: 'readingEgyptianDesc',
      endpoint: ApiConstants.egyptianPrediction,
      icon: Icons.temple_hindu_rounded,
      accentColor: AppColors.accentBlue,
      category: ReadingCategory.spiritual,
    ),

    // ── Love & Relationships ──
    ReadingType(
      id: 'erotic_love',
      nameKey: 'readingEroticLove',
      descriptionKey: 'readingEroticLoveDesc',
      endpoint: ApiConstants.eroticLoveReading,
      icon: Icons.local_fire_department_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
    ),
    ReadingType(
      id: 'ex_flame',
      nameKey: 'readingExFlame',
      descriptionKey: 'readingExFlameDesc',
      endpoint: ApiConstants.exFlameReading,
      icon: Icons.whatshot_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
    ),
    ReadingType(
      id: 'flirt_love',
      nameKey: 'readingFlirtLove',
      descriptionKey: 'readingFlirtLoveDesc',
      endpoint: ApiConstants.flirtLoveReading,
      icon: Icons.favorite_border_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
    ),
    ReadingType(
      id: 'heartbreak',
      nameKey: 'readingHeartbreak',
      descriptionKey: 'readingHeartbreakDesc',
      endpoint: ApiConstants.heartbreakReading,
      icon: Icons.heart_broken_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
      inputType: ReadingInputType.cardSelect,
    ),
    ReadingType(
      id: 'in_depth_love',
      nameKey: 'readingInDepthLove',
      descriptionKey: 'readingInDepthLoveDesc',
      endpoint: ApiConstants.inDepthLoveReading,
      icon: Icons.favorite_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
    ),
    ReadingType(
      id: 'know_your_friend',
      nameKey: 'readingKnowFriend',
      descriptionKey: 'readingKnowFriendDesc',
      endpoint: ApiConstants.knowYourFriendReading,
      icon: Icons.people_outline_rounded,
      accentColor: AppColors.categoryLife,
      category: ReadingCategory.life,
    ),

    // ── Compatibility / Multi-input ──
    ReadingType(
      id: 'love_compatibility',
      nameKey: 'readingLoveCompat',
      descriptionKey: 'readingLoveCompatDesc',
      endpoint: ApiConstants.loveCompatibility,
      icon: Icons.compare_arrows_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
      inputType: ReadingInputType.twoSigns,
    ),
    ReadingType(
      id: 'love_triangle',
      nameKey: 'readingLoveTriangle',
      descriptionKey: 'readingLoveTriangleDesc',
      endpoint: ApiConstants.loveTriangleReading,
      icon: Icons.change_history_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
      inputType: ReadingInputType.cardSelect,
    ),
    ReadingType(
      id: 'made_for_each_other',
      nameKey: 'readingMadeForEachOther',
      descriptionKey: 'readingMadeForEachOtherDesc',
      endpoint: ApiConstants.madeForEachOtherReading,
      icon: Icons.all_inclusive_rounded,
      accentColor: AppColors.categoryLove,
      category: ReadingCategory.love,
    ),
    ReadingType(
      id: 'power_life',
      nameKey: 'readingPowerLife',
      descriptionKey: 'readingPowerLifeDesc',
      endpoint: ApiConstants.powerLifeReading,
      icon: Icons.bolt_rounded,
      accentColor: AppColors.categoryLife,
      category: ReadingCategory.life,
    ),
    ReadingType(
      id: 'past_lives_connection',
      nameKey: 'readingPastLives',
      descriptionKey: 'readingPastLivesDesc',
      endpoint: ApiConstants.pastLivesConnectionReading,
      icon: Icons.history_rounded,
      accentColor: AppColors.categorySpirituality,
      category: ReadingCategory.spiritual,
    ),
  ];

  /// Get readings by category.
  static List<ReadingType> byCategory(ReadingCategory category) {
    return all.where((r) => r.category == category).toList();
  }

  /// Find a reading by its ID.
  static ReadingType? byId(String id) {
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
