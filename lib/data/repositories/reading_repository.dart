import '../models/api_response.dart';
import '../models/reading_result.dart';
import '../models/dual_card_result.dart';
import '../models/love_compatibility_result.dart';
import '../models/coffee_cup_result.dart';
import '../models/special_results.dart';
import '../services/divine_api_service.dart';
import '../services/translation_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/reading_types.dart';

/// Repository layer abstracting the DivineApiService for the state layer.
///
/// Fetches tarot readings and automatically provides seamless translation
/// via TranslationService if non-English locale is requested.
class ReadingRepository {
  final DivineApiService _apiService;

  ReadingRepository({DivineApiService? apiService})
      : _apiService = apiService ?? DivineApiService();

  /// Get a simple reading with automatic translation if needed.
  Future<ApiResponse<ReadingResult>> getSimpleReading({
    required String endpoint,
    required String language,
  }) async {
    final response = await _apiService.getSimpleReading(
      endpoint: endpoint,
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateReadingResult(response.data!, language);
      return ApiResponse<ReadingResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Get a card-select reading with automatic translation if needed.
  Future<ApiResponse<ReadingResult>> getCardSelectReading({
    required String endpoint,
    required String cardImage,
    required String language,
  }) async {
    final response = await _apiService.getCardSelectReading(
      endpoint: endpoint,
      cardImage: cardImage,
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateReadingResult(response.data!, language);
      return ApiResponse<ReadingResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Get a dual-card reading with automatic translation if needed.
  Future<ApiResponse<DualCardResult>> getDualCardReading({
    required String endpoint,
    required String cardImage,
    required String language,
  }) async {
    final response = await _apiService.getDualCardReading(
      endpoint: endpoint,
      cardImage: cardImage,
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateDualCardResult(response.data!, language);
      return ApiResponse<DualCardResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Get love compatibility with automatic translation if needed.
  Future<ApiResponse<LoveCompatibilityResult>> getLoveCompatibility({
    required String sign1,
    required String sign2,
    required String language,
  }) async {
    final response = await _apiService.getLoveCompatibility(
      sign1: sign1,
      sign2: sign2,
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateLoveCompatibility(response.data!, language);
      return ApiResponse<LoveCompatibilityResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Get love triangle reading with automatic translation if needed.
  Future<ApiResponse<LoveTriangleResult>> getLoveTriangleReading({
    required String cardImage,
    required String language,
  }) async {
    final response = await _apiService.getLoveTriangleReading(
      cardImage: cardImage,
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateLoveTriangle(response.data!, language);
      return ApiResponse<LoveTriangleResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Get coffee cup reading with automatic translation if needed.
  Future<ApiResponse<CoffeeCupResult>> getCoffeeCupReading({
    required String language,
  }) async {
    final response = await _apiService.getCoffeeCupReading(
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateCoffeeCup(response.data!, language);
      return ApiResponse<CoffeeCupResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Get fortune cookie with automatic translation if needed.
  Future<ApiResponse<FortuneCookieResult>> getFortuneCookie({
    required String language,
  }) async {
    final response = await _apiService.getFortuneCookie(
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateFortuneCookie(response.data!, language);
      return ApiResponse<FortuneCookieResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Get Which Animal Are You reading with automatic translation if needed.
  Future<ApiResponse<ReadingResult>> getWhichAnimalReading({
    required String fullName,
    required int day,
    required int month,
    required int year,
    required String language,
  }) async {
    final response = await _apiService.getWhichAnimalReading(
      fullName: fullName,
      day: day,
      month: month,
      year: year,
      language: ApiConstants.enableTranslator ? language : 'en',
    );

    if (response.isSuccess && response.data != null && language.toLowerCase() != 'en') {
      final translatedData = await _translateReadingResult(response.data!, language);
      return ApiResponse<ReadingResult>(
        success: response.success,
        data: translatedData,
        message: response.message,
      );
    }
    return response;
  }

  /// Convenience method: dispatch a reading by its ReadingType definition.
  Future<ApiResponse<dynamic>> getReading({
    required ReadingType readingType,
    required String language,
    String? cardImage,
    String? sign1,
    String? sign2,
    String? sign,
  }) {
    if (readingType.endpoint == ApiConstants.whichAnimalAreYouReading) {
      return getWhichAnimalReading(
        fullName: 'Friend',
        day: 15,
        month: 8,
        year: 1995,
        language: language,
      );
    }

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

    if (readingType.endpoint == ApiConstants.heartbreakReading ||
        readingType.endpoint == ApiConstants.divineMagicReading) {
      return getDualCardReading(
        endpoint: readingType.endpoint,
        cardImage: cardImage ?? '1',
        language: language,
      );
    }

    if (readingType.inputType == ReadingInputType.cardSelect) {
      return getCardSelectReading(
        endpoint: readingType.endpoint,
        cardImage: cardImage ?? '1',
        language: language,
      );
    }

    return getSimpleReading(
      endpoint: readingType.endpoint,
      language: language,
    );
  }

  // ──────────────────────── Model Translators ────────────────────────

  Future<ReadingResult> _translateReadingResult(ReadingResult res, String lang) async {
    return ReadingResult(
      card: res.card,
      category: await TranslationService.translate(res.category, lang),
      yesNo: res.yesNo,
      result: await TranslationService.translate(res.result, lang),
      career: await TranslationService.translate(res.career, lang),
      love: await TranslationService.translate(res.love, lang),
      finance: await TranslationService.translate(res.finance, lang),
      image: res.image,
      image2: res.image2,
      image3: res.image3,
      cardImage: res.cardImage,
    );
  }

  Future<DualCardResult> _translateDualCardResult(DualCardResult res, String lang) async {
    return DualCardResult(
      card1: res.card1,
      card2: res.card2,
      card1Image: res.card1Image,
      card2Image: res.card2Image,
      cause: await TranslationService.translate(res.cause, lang),
      remedy: await TranslationService.translate(res.remedy, lang),
      advise: await TranslationService.translate(res.advise, lang),
      ying: await TranslationService.translate(res.ying, lang),
      yang: await TranslationService.translate(res.yang, lang),
    );
  }

  Future<LoveCompatibilityResult> _translateLoveCompatibility(LoveCompatibilityResult res, String lang) async {
    return LoveCompatibilityResult(
      sign1: res.sign1,
      sign2: res.sign2,
      score: res.score,
      overallCompatibility: await TranslationService.translate(res.overallCompatibility, lang),
      positiveAspects: await TranslationService.translate(res.positiveAspects, lang),
      negativeAspects: await TranslationService.translate(res.negativeAspects, lang),
      idealDate: await TranslationService.translate(res.idealDate, lang),
    );
  }

  Future<CoffeeCupResult> _translateCoffeeCup(CoffeeCupResult res, String lang) async {
    return CoffeeCupResult(
      presentTitle: await TranslationService.translate(res.presentTitle, lang),
      presentContent: await TranslationService.translate(res.presentContent, lang),
      presentImage: res.presentImage,
      nearFutureTitle: await TranslationService.translate(res.nearFutureTitle, lang),
      nearFutureContent: await TranslationService.translate(res.nearFutureContent, lang),
      nearFutureImage: res.nearFutureImage,
      distantFutureTitle: await TranslationService.translate(res.distantFutureTitle, lang),
      distantFutureContent: await TranslationService.translate(res.distantFutureContent, lang),
      distantFutureImage: res.distantFutureImage,
    );
  }

  Future<LoveTriangleResult> _translateLoveTriangle(LoveTriangleResult res, String lang) async {
    return LoveTriangleResult(
      card1: res.card1,
      card2: res.card2,
      card3: res.card3,
      card1Image: res.card1Image,
      card2Image: res.card2Image,
      card3Image: res.card3Image,
      your: await TranslationService.translate(res.your, lang),
      lover1: await TranslationService.translate(res.lover1, lang),
      lover2: await TranslationService.translate(res.lover2, lang),
    );
  }

  Future<FortuneCookieResult> _translateFortuneCookie(FortuneCookieResult res, String lang) async {
    return FortuneCookieResult(
      result: await TranslationService.translate(res.result, lang),
    );
  }
}
