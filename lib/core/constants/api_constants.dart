import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API constants sourced from environment and the DivineAPI OpenAPI spec.
class ApiConstants {
  ApiConstants._();

  /// Default Base URL for DivineAPI Horoscope & Tarot endpoints.
  static String get baseUrl =>
      dotenv.env['DIVINE_API_BASE_URL'] ?? 'https://astroapi-5.divineapi.com';

  /// Domain host URLs for different DivineAPI service tiers:
  static const String hostHoroscopeTarot = 'https://astroapi-5.divineapi.com';
  static const String hostIndianPanchang = 'https://astroapi-3.divineapi.com';
  static const String hostWesternNumerology = 'https://astroapi-4.divineapi.com';
  static const String hostLifestyleCalculators = 'https://astroapi-7.divineapi.com';
  static const String hostWesternCharts = 'https://astroapi-8.divineapi.com';
  static const String hostPdfReports = 'https://pdf.divineapi.com';

  /// API key loaded from .env file.
  static String get apiKey => dotenv.env['DIVINE_API_KEY'] ?? '';

  /// Auth Token (JWT) loaded from .env file. Defaults to apiKey if absent.
  static String get authToken =>
      dotenv.env['DIVINE_API_AUTH_TOKEN'] ?? apiKey;

  // ──────────────────────────── Horoscopes ────────────────────────────────
  static const String dailyHoroscope = '/api/v5/daily-horoscope';
  static const String weeklyHoroscope = '/api/v5/weekly-horoscope';
  static const String monthlyHoroscope = '/api/v5/monthly-horoscope';
  static const String yearlyHoroscope = '/api/v5/yearly-horoscope';
  static const String chineseHoroscope = '/api/v3/chinese-horoscope';
  static const String numerologyHoroscope = '/api/v2/numerology-horoscope';

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
  static const String pastPresentFutureReading =
      '/api/v3/past-present-future-reading';
  static const String whichAnimalAreYouReading =
      '/api/v2/which-animal-are-you-reading';
  static const String wisdomReading = '/api/v2/wisdom-reading';

  // ──────────────────────── Indian / Panchang / Kundli ──────────────────────
  static const String panchang = '/indian-api/v2/panchang';
  static const String kundliChartD1 = '/indian-api/v1/horoscope-chart/D1';
  static const String planetaryPositions = '/indian-api/v2/planetary-positions';
  static const String ashtakootMilan = '/indian-api/v2/ashtakoot-milan';
  static const String kaalSarpaDosha = '/indian-api/v1/kaal-sarpa-yoga';
  static const String manglikDosha = '/indian-api/v2/manglik-dosha';

  // ──────────────────────── Lifestyle & Calculators ────────────────────────
  static const String zodiacGiftGuru = '/api/v1/zodiac-gift-guru';
  static const String beautyByTheStars = '/api/v1/beauty-by-the-stars';
  static const String astroChicPicks = '/api/v1/astro-chic-picks';
  static const String flamesCalculator = '/calculator/v1/flames-calculator';
  static const String loveCalculator = '/calculator/v1/love-calculator';

  // ──────────────────────── Western & Numerology ────────────────────────────
  static const String numerologyCoreNumbers = '/numerology/v1/core-numbers';
  static const String loshuGrid = '/numerology/v1/loshu-grid';
  static const String westernAscendantReport = '/western-api/v1/ascendant-report';
  static const String westernMoonPhases = '/western-api/v2/moon-phases';
}

