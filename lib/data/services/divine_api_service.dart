import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../models/api_response.dart';
import '../models/reading_result.dart';
import '../models/dual_card_result.dart';
import '../models/love_compatibility_result.dart';
import '../models/coffee_cup_result.dart';
import '../models/special_results.dart';
import '../models/horoscope_result.dart';

/// HTTP client for all DivineAPI endpoints.
///
/// Supports POST with multipart/form-data across all DivineAPI host domains.
/// Auth: Bearer token header + api_key body param.
class DivineApiService {
  final http.Client _client;

  DivineApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Build the full Uri for an endpoint, with optional domain host override.
  Uri _buildUri(String endpoint, {String? host}) {
    final base = host ?? ApiConstants.baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$base$cleanEndpoint');
  }

  /// Create a multipart request with standard auth fields, resolving language & host dynamically.
  http.MultipartRequest _createRequest(
    String endpoint, {
    required String? language,
    String? customHost,
  }) {
    final validLanguage = ApiConstants.resolveLanguageCode(language);
    final host = customHost ?? ApiConstants.getHostForLanguage(validLanguage);
    final request =
        http.MultipartRequest('POST', _buildUri(endpoint, host: host));
    request.headers['Authorization'] = 'Bearer ${ApiConstants.authToken}';
    request.fields['api_key'] = ApiConstants.apiKey;
    request.fields['lan'] = validLanguage;
    return request;
  }

  /// Send a request and parse the JSON response.
  Future<Map<String, dynamic>> _sendRequest(
    http.MultipartRequest request,
  ) async {
    try {
      final streamedResponse = await request.send().timeout(
            AppConstants.apiTimeout,
          );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json;
    } catch (e) {
      rethrow;
    }
  }

  // ────────────────────────── Horoscopes ──────────────────────────────

  /// Get Daily Horoscope prediction for a zodiac sign.
  Future<ApiResponse<HoroscopeResult>> getDailyHoroscope({
    required String sign,
    String hDay = 'today',
    String timeZone = '5.5',
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.dailyHoroscope,
      language: language,
    );
    request.fields['sign'] = sign.toLowerCase();
    request.fields['h_day'] = hDay;
    request.fields['tzone'] = timeZone;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, HoroscopeResult.fromJson);
  }

  /// Get Weekly Horoscope prediction for a zodiac sign.
  Future<ApiResponse<HoroscopeResult>> getWeeklyHoroscope({
    required String sign,
    String week = 'current',
    String timeZone = '5.5',
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.weeklyHoroscope,
      language: language,
    );
    request.fields['sign'] = sign.toLowerCase();
    request.fields['week'] = week;
    request.fields['tzone'] = timeZone;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, HoroscopeResult.fromJson);
  }

  /// Get Monthly Horoscope prediction for a zodiac sign.
  Future<ApiResponse<HoroscopeResult>> getMonthlyHoroscope({
    required String sign,
    String month = 'current',
    String timeZone = '5.5',
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.monthlyHoroscope,
      language: language,
    );
    request.fields['sign'] = sign.toLowerCase();
    request.fields['month'] = month;
    request.fields['tzone'] = timeZone;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, HoroscopeResult.fromJson);
  }

  /// Get Yearly Horoscope prediction for a zodiac sign.
  Future<ApiResponse<HoroscopeResult>> getYearlyHoroscope({
    required String sign,
    String year = 'current',
    String timeZone = '5.5',
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.yearlyHoroscope,
      language: language,
    );
    request.fields['sign'] = sign.toLowerCase();
    request.fields['year'] = year;
    request.fields['tzone'] = timeZone;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, HoroscopeResult.fromJson);
  }

  // ────────────────────────── Simple Readings ──────────────────────────

  /// Generic simple reading (tarot/spiritual endpoints).
  Future<ApiResponse<ReadingResult>> getSimpleReading({
    required String endpoint,
    required String language,
    String? host,
  }) async {
    final request = _createRequest(
      endpoint,
      language: language,
      customHost: host,
    );

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, ReadingResult.fromJson);
  }

  // ────────────────────── Card-Select Readings ────────────────────────

  /// Reading that requires selecting a card (1-22 for Major Arcana).
  Future<ApiResponse<ReadingResult>> getCardSelectReading({
    required String endpoint,
    required String cardImage,
    required String language,
    String? host,
  }) async {
    final request = _createRequest(
      endpoint,
      language: language,
      customHost: host,
    );
    request.fields['card_image'] = cardImage;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, ReadingResult.fromJson);
  }

  // ────────────────────── Dual-Card Readings ──────────────────────────

  /// Dual-card reading with card_image selection.
  Future<ApiResponse<DualCardResult>> getDualCardReading({
    required String endpoint,
    required String cardImage,
    required String language,
    String? host,
  }) async {
    final request = _createRequest(
      endpoint,
      language: language,
      customHost: host,
    );
    request.fields['card_image'] = cardImage;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, DualCardResult.fromJson);
  }

  // ────────────────── Love Compatibility ──────────────────────────────

  /// Love compatibility between two zodiac signs.
  Future<ApiResponse<LoveCompatibilityResult>> getLoveCompatibility({
    required String sign1,
    required String sign2,
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.loveCompatibility,
      language: language,
    );
    request.fields['sign_1'] = sign1;
    request.fields['sign_2'] = sign2;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, LoveCompatibilityResult.fromJson);
  }

  // ──────────────────── Love Triangle ─────────────────────────────────

  /// Love triangle reading — returns 3 cards with perspectives.
  Future<ApiResponse<LoveTriangleResult>> getLoveTriangleReading({
    required String cardImage,
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.loveTriangleReading,
      language: language,
    );
    request.fields['card_image'] = cardImage;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, LoveTriangleResult.fromJson);
  }

  // ──────────────────── Coffee Cup ────────────────────────────────────

  /// Coffee cup reading — 3 temporal positions.
  Future<ApiResponse<CoffeeCupResult>> getCoffeeCupReading({
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.coffeeCupReading,
      language: language,
    );

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, CoffeeCupResult.fromJson);
  }

  // ──────────────────── Fortune Cookie ────────────────────────────────

  /// Fortune cookie — simple wisdom message.
  Future<ApiResponse<FortuneCookieResult>> getFortuneCookie({
    required String language,
  }) async {
    final request = _createRequest(
      ApiConstants.fortuneCookie,
      language: language,
    );

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, FortuneCookieResult.fromJson);
  }

  /// Dispose the HTTP client.
  void dispose() {
    _client.close();
  }
}

