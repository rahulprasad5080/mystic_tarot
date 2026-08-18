import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API constants sourced from environment and the DivineAPI OpenAPI spec.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the DivineAPI Horoscope & Tarot v2 endpoints.
  static String get baseUrl =>
      dotenv.env['DIVINE_API_BASE_URL'] ?? 'https://astroapi-5.divineapi.com';

  /// API key loaded from .env file.
  static String get apiKey => dotenv.env['DIVINE_API_KEY'] ?? '';

  /// Auth Token (JWT) loaded from .env file. Defaults to apiKey if absent.
  static String get authToken =>
      dotenv.env['DIVINE_API_AUTH_TOKEN'] ?? apiKey;

  // ──────────────────────────── Tarot / Readings ────────────────────────────

  static const String yesOrNoTarot = '/api/v2/yes-or-no-tarot';
  static const String dailyTarot = '/api/v2/daily-tarot';
  static const String fortuneCookie = '/api/v2/fortune-cookie';
  static const String coffeeCupReading = '/api/v2/coffee-cup-reading';
  static const String careerDailyReading = '/api/v3/career-daily-reading';
  static const String divineAngelReading = '/api/v3/divine-angel-reading';
  static const String divineMagicReading = '/api/v2/divine-magic-reading';
  static const String dreamComeTrueReading = '/api/v3/dream-come-true-reading';
  static const String egyptianPrediction = '/api/v3/egyptian-prediction';
  static const String eroticLoveReading = '/api/v3/erotic-love-reading';
  static const String exFlameReading = '/api/v3/ex-flame-reading';
  static const String flirtLoveReading = '/api/v3/flirt-love-reading';
  static const String heartbreakReading = '/api/v2/heartbreak-reading';
  static const String inDepthLoveReading = '/api/v3/in-depth-love-reading';
  static const String knowYourFriendReading =
      '/api/v3/know-your-friend-reading';
  static const String loveCompatibility = '/api/v2/love-compatibility';
  static const String loveTriangleReading = '/api/v2/love-triangle-reading';
  static const String madeForEachOtherReading =
      '/api/v3/made-for-each-other-or-not-reading';
  static const String powerLifeReading = '/api/v3/power-life-reading';
  static const String pastLivesConnectionReading =
      '/api/v3/past-lives-connection-reading';

  // ──────────────────────── Bonus / Horoscope Endpoints ─────────────────────

  static const String dailyHoroscope = '/api/v5/daily-horoscope';
  static const String weeklyHoroscope = '/api/v5/weekly-horoscope';
  static const String monthlyHoroscope = '/api/v5/monthly-horoscope';
  static const String yearlyHoroscope = '/api/v5/yearly-horoscope';
  static const String chineseHoroscope = '/api/v3/chinese-horoscope';
  static const String numerologyHoroscope = '/api/v2/numerology-horoscope';
  static const String pastPresentFutureReading =
      '/api/v3/past-present-future-reading';
  static const String whichAnimalAreYouReading =
      '/api/v2/which-animal-are-you-reading';
  static const String wisdomReading = '/api/v2/wisdom-reading';
}
