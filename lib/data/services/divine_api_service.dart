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

/// HTTP client for all DivineAPI endpoints.
///
/// All endpoints are POST with multipart/form-data.
/// Auth: Bearer token header + api_key body param.
/// The API returns HTTP 200 even on errors — check `success` field.
class DivineApiService {
  final http.Client _client;

  DivineApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Build the full URL for an endpoint.
  Uri _buildUri(String endpoint) {
    return Uri.parse('${ApiConstants.baseUrl}$endpoint');
  }

  /// Create a multipart request with standard auth fields.
  http.MultipartRequest _createRequest(String endpoint) {
    final request = http.MultipartRequest('POST', _buildUri(endpoint));
    request.headers['Authorization'] = 'Bearer ${ApiConstants.authToken}';
    request.fields['api_key'] = ApiConstants.apiKey;
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

  // ────────────────────────── Simple Readings ──────────────────────────
  // These require only api_key + optional lan.

  /// Generic simple reading (most tarot/spiritual endpoints).
  Future<ApiResponse<ReadingResult>> getSimpleReading({
    required String endpoint,
    required String language,
  }) async {
    final request = _createRequest(endpoint);
    request.fields['lan'] = language;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, ReadingResult.fromJson);
  }

  // ────────────────────── Card-Select Readings ────────────────────────
  // These require api_key + card_image (1-22) + lan.

  /// Reading that requires selecting a card (1-22 for Major Arcana).
  Future<ApiResponse<ReadingResult>> getCardSelectReading({
    required String endpoint,
    required String cardImage,
    required String language,
  }) async {
    final request = _createRequest(endpoint);
    request.fields['card_image'] = cardImage;
    request.fields['lan'] = language;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, ReadingResult.fromJson);
  }

  // ────────────────────── Dual-Card Readings ──────────────────────────
  // Heartbreak, Divine Magic, Wisdom — return card1 + card2.

  /// Dual-card reading with card_image selection.
  Future<ApiResponse<DualCardResult>> getDualCardReading({
    required String endpoint,
    required String cardImage,
    required String language,
  }) async {
    final request = _createRequest(endpoint);
    request.fields['card_image'] = cardImage;
    request.fields['lan'] = language;

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
    final request = _createRequest(ApiConstants.loveCompatibility);
    request.fields['sign_1'] = sign1;
    request.fields['sign_2'] = sign2;
    request.fields['lan'] = language;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, LoveCompatibilityResult.fromJson);
  }

  // ──────────────────── Love Triangle ─────────────────────────────────

  /// Love triangle reading — returns 3 cards with perspectives.
  Future<ApiResponse<LoveTriangleResult>> getLoveTriangleReading({
    required String cardImage,
    required String language,
  }) async {
    final request = _createRequest(ApiConstants.loveTriangleReading);
    request.fields['card_image'] = cardImage;
    request.fields['lan'] = language;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, LoveTriangleResult.fromJson);
  }

  // ──────────────────── Coffee Cup ────────────────────────────────────

  /// Coffee cup reading — 3 temporal positions.
  Future<ApiResponse<CoffeeCupResult>> getCoffeeCupReading({
    required String language,
  }) async {
    final request = _createRequest(ApiConstants.coffeeCupReading);
    request.fields['lan'] = language;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, CoffeeCupResult.fromJson);
  }

  // ──────────────────── Fortune Cookie ────────────────────────────────

  /// Fortune cookie — simple wisdom message.
  Future<ApiResponse<FortuneCookieResult>> getFortuneCookie({
    required String language,
  }) async {
    final request = _createRequest(ApiConstants.fortuneCookie);
    request.fields['lan'] = language;

    final json = await _sendRequest(request);
    return ApiResponse.fromJson(json, FortuneCookieResult.fromJson);
  }

  /// Dispose the HTTP client.
  void dispose() {
    _client.close();
  }
}
