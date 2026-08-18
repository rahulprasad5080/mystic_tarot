/// App-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Mystic Tarot';
  static const String appVersion = '1.0.0';

  // SharedPreferences keys
  static const String prefLocale = 'selected_locale';
  static const String prefFirstLaunch = 'is_first_launch';

  // API timeout
  static const Duration apiTimeout = Duration(seconds: 30);

  // Default timezone offset
  static const String defaultTimezone = '5.5';

  // Zodiac signs (Western)
  static const List<String> zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  // Chinese zodiac signs
  static const List<String> chineseZodiacSigns = [
    'RAT',
    'OX',
    'TIGER',
    'RABBIT',
    'DRAGON',
    'SNAKE',
    'HORSE',
    'GOAT',
    'MONKEY',
    'ROOSTER',
    'DOG',
    'PIG',
  ];

  // Zodiac sign emojis for UI
  static const Map<String, String> zodiacEmojis = {
    'Aries': '♈',
    'Taurus': '♉',
    'Gemini': '♊',
    'Cancer': '♋',
    'Leo': '♌',
    'Virgo': '♍',
    'Libra': '♎',
    'Scorpio': '♏',
    'Sagittarius': '♐',
    'Capricorn': '♑',
    'Aquarius': '♒',
    'Pisces': '♓',
  };

  // Supported languages with native names, badges, and flags
  static const List<LanguageInfo> supportedLanguages = [
    LanguageInfo(code: 'en', name: 'English', nativeName: 'English', badge: 'EN', flag: '🇬🇧'),
    LanguageInfo(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', badge: 'HI', flag: '🇮🇳'),
    LanguageInfo(code: 'zh', name: 'Chinese', nativeName: '中文', badge: 'ZH', flag: '🇨🇳'),
    LanguageInfo(code: 'ja', name: 'Japanese', nativeName: '日本語', badge: 'JA', flag: '🇯🇵'),
    LanguageInfo(code: 'ar', name: 'Arabic', nativeName: 'العربية', badge: 'AR', flag: '🇸🇦', isRtl: true),
    LanguageInfo(code: 'ru', name: 'Russian', nativeName: 'Русский', badge: 'RU', flag: '🇷🇺'),
    LanguageInfo(code: 'pt', name: 'Portuguese', nativeName: 'Português', badge: 'PT', flag: '🇧🇷'),
    LanguageInfo(code: 'es', name: 'Spanish', nativeName: 'Español', badge: 'ES', flag: '🇪🇸'),
    LanguageInfo(code: 'fr', name: 'French', nativeName: 'Français', badge: 'FR', flag: '🇫🇷'),
    LanguageInfo(code: 'de', name: 'German', nativeName: 'Deutsch', badge: 'DE', flag: '🇩🇪'),
    LanguageInfo(code: 'it', name: 'Italian', nativeName: 'Italiano', badge: 'IT', flag: '🇮🇹'),
    LanguageInfo(code: 'nl', name: 'Dutch', nativeName: 'Nederlands', badge: 'NL', flag: '🇳🇱'),
    LanguageInfo(code: 'pl', name: 'Polish', nativeName: 'Polski', badge: 'PL', flag: '🇵🇱'),
    LanguageInfo(code: 'tr', name: 'Turkish', nativeName: 'Türkçe', badge: 'TR', flag: '🇹🇷'),
    LanguageInfo(code: 'uk', name: 'Ukrainian', nativeName: 'Українська', badge: 'UK', flag: '🇺🇦'),
    LanguageInfo(code: 'hu', name: 'Hungarian', nativeName: 'Magyar', badge: 'HU', flag: '🇭🇺'),
    LanguageInfo(code: 'el', name: 'Greek', nativeName: 'Ελληνικά', badge: 'EL', flag: '🇬🇷'),
    LanguageInfo(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', badge: 'BN', flag: '🇧🇩'),
    LanguageInfo(code: 'mr', name: 'Marathi', nativeName: 'मराठी', badge: 'MR', flag: '🇮🇳'),
    LanguageInfo(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', badge: 'TA', flag: '🇮🇳'),
    LanguageInfo(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', badge: 'TE', flag: '🇮🇳'),
    LanguageInfo(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', badge: 'ML', flag: '🇮🇳'),
    LanguageInfo(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', badge: 'KN', flag: '🇮🇳'),
    LanguageInfo(code: 'tl', name: 'Filipino', nativeName: 'Filipino', badge: 'TL', flag: '🇵🇭'),
    LanguageInfo(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia', badge: 'ID', flag: '🇮🇩'),
  ];
}

/// Model for language information including RTL support and badge.
class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String badge;
  final String flag;
  final bool isRtl;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.badge,
    required this.flag,
    this.isRtl = false,
  });
}
