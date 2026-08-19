import '../models/api_response.dart';
import '../models/reading_result.dart';
import '../models/dual_card_result.dart';
import '../models/love_compatibility_result.dart';
import '../models/coffee_cup_result.dart';
import '../models/special_results.dart';
import '../models/horoscope_result.dart';
import '../services/divine_api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/reading_types.dart';

/// Repository layer abstracting the DivineApiService for the state layer.
///
/// Provides typed access to all reading endpoints. Real API responses are
/// returned as-is — errors propagate to the UI, which surfaces them with a
/// retry action instead of falling back to placeholder data.
class ReadingRepository {
  final DivineApiService _apiService;

  ReadingRepository({DivineApiService? apiService})
      : _apiService = apiService ?? DivineApiService();

  /// Get Daily Horoscope prediction for a sign.
  Future<ApiResponse<HoroscopeResult>> getDailyHoroscope({
    required String sign,
    String hDay = 'today',
    required String language,
  }) {
    return _apiService.getDailyHoroscope(
      sign: sign,
      hDay: hDay,
      language: language,
    );
  }

  /// Get Weekly Horoscope prediction for a sign.
  Future<ApiResponse<HoroscopeResult>> getWeeklyHoroscope({
    required String sign,
    String week = 'current',
    required String language,
  }) {
    return _apiService.getWeeklyHoroscope(
      sign: sign,
      week: week,
      language: language,
    );
  }

  /// Get Monthly Horoscope prediction for a sign.
  Future<ApiResponse<HoroscopeResult>> getMonthlyHoroscope({
    required String sign,
    String month = 'current',
    required String language,
  }) {
    return _apiService.getMonthlyHoroscope(
      sign: sign,
      month: month,
      language: language,
    );
  }

  /// Get Yearly Horoscope prediction for a sign.
  Future<ApiResponse<HoroscopeResult>> getYearlyHoroscope({
    required String sign,
    String year = 'current',
    required String language,
  }) {
    return _apiService.getYearlyHoroscope(
      sign: sign,
      year: year,
      language: language,
    );
  }

  /// Get a simple reading (no extra input required).
  Future<ApiResponse<ReadingResult>> getSimpleReading({
    required String endpoint,
    required String language,
  }) {
    return _apiService.getSimpleReading(endpoint: endpoint, language: language);
  }

  /// Get a card-select reading (requires card_image 1-22).
  Future<ApiResponse<ReadingResult>> getCardSelectReading({
    required String endpoint,
    required String cardImage,
    required String language,
  }) {
    return _apiService.getCardSelectReading(
      endpoint: endpoint,
      cardImage: cardImage,
      language: language,
    );
  }

  /// Get a dual-card reading (Heartbreak, Divine Magic, Wisdom).
  Future<ApiResponse<DualCardResult>> getDualCardReading({
    required String endpoint,
    required String cardImage,
    required String language,
  }) {
    return _apiService.getDualCardReading(
      endpoint: endpoint,
      cardImage: cardImage,
      language: language,
    );
  }

  /// Get love compatibility between two signs.
  Future<ApiResponse<LoveCompatibilityResult>> getLoveCompatibility({
    required String sign1,
    required String sign2,
    required String language,
  }) {
    return _apiService.getLoveCompatibility(
      sign1: sign1,
      sign2: sign2,
      language: language,
    );
  }

  /// Get love triangle reading.
  Future<ApiResponse<LoveTriangleResult>> getLoveTriangleReading({
    required String cardImage,
    required String language,
  }) {
    return _apiService.getLoveTriangleReading(
      cardImage: cardImage,
      language: language,
    );
  }

  /// Get coffee cup reading.
  Future<ApiResponse<CoffeeCupResult>> getCoffeeCupReading({
    required String language,
  }) {
    return _apiService.getCoffeeCupReading(language: language);
  }

  /// Get fortune cookie.
  Future<ApiResponse<FortuneCookieResult>> getFortuneCookie({
    required String language,
  }) {
    return _apiService.getFortuneCookie(language: language);
  }

  /// Convenience method: dispatch a reading by its ReadingType definition.
  /// Returns a generic result; the caller should cast based on type.
  Future<ApiResponse<dynamic>> getReading({
    required ReadingType readingType,
    required String language,
    String? cardImage,
    String? sign1,
    String? sign2,
    String? sign,
  }) {
    // Horoscope endpoints
    if (readingType.endpoint == ApiConstants.dailyHoroscope) {
      return getDailyHoroscope(
        sign: sign ?? sign1 ?? 'Aries',
        language: language,
      );
    }
    if (readingType.endpoint == ApiConstants.weeklyHoroscope) {
      return getWeeklyHoroscope(
        sign: sign ?? sign1 ?? 'Aries',
        language: language,
      );
    }
    if (readingType.endpoint == ApiConstants.monthlyHoroscope) {
      return getMonthlyHoroscope(
        sign: sign ?? sign1 ?? 'Aries',
        language: language,
      );
    }
    if (readingType.endpoint == ApiConstants.yearlyHoroscope) {
      return getYearlyHoroscope(
        sign: sign ?? sign1 ?? 'Aries',
        language: language,
      );
    }

    // Special endpoints with unique response shapes
    if (readingType.endpoint == ApiConstants.loveCompatibility) {
      return getLoveCompatibility(
        sign1: sign1 ?? 'Aries',
        sign2: sign2 ?? 'Aries',
        language: language,
      );
    }

    if (readingType.endpoint == ApiConstants.coffeeCupReading) {
      return getCoffeeCupReading(language: language);
    }

    if (readingType.endpoint == ApiConstants.fortuneCookie) {
      return getFortuneCookie(language: language);
    }

    if (readingType.endpoint == ApiConstants.loveTriangleReading) {
      return getLoveTriangleReading(
        cardImage: cardImage ?? '1',
        language: language,
      );
    }

    // Dual-card readings
    if (readingType.endpoint == ApiConstants.heartbreakReading ||
        readingType.endpoint == ApiConstants.divineMagicReading) {
      return getDualCardReading(
        endpoint: readingType.endpoint,
        cardImage: cardImage ?? '1',
        language: language,
      );
    }

    // Card-select readings (single card result)
    if (readingType.inputType == ReadingInputType.cardSelect) {
      return getCardSelectReading(
        endpoint: readingType.endpoint,
        cardImage: cardImage ?? '1',
        language: language,
      );
    }

    // Default: simple reading
    return getSimpleReading(
      endpoint: readingType.endpoint,
      language: language,
    );
  }
}

