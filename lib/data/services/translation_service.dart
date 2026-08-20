import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service providing fast, free translation via Google Translate GTX endpoint.
class TranslationService {
  static final http.Client _client = http.Client();
  static final Map<String, String> _cache = {};

  /// Maps app internal language codes to standard Google Translate ISO 639-1 codes.
  static String _normalizeLanguageCode(String code) {
    final lower = code.toLowerCase().trim();
    switch (lower) {
      case 'tl': // App code for Telugu -> Google Translate ISO 'te'
        return 'te';
      case 'te':
        return 'te';
      case 'ma': // App code for Marathi -> Google Translate ISO 'mr'
        return 'mr';
      case 'tm': // App code for Tamil -> Google Translate ISO 'ta'
        return 'ta';
      case 'gr': // App code for Greek -> Google Translate ISO 'el'
        return 'el';
      case 'bah': // App code for Indonesian -> Google Translate ISO 'id'
        return 'id';
      case 'ta': // App code for Tagalog/Filipino -> Google Translate ISO 'tl'
        return 'tl';
      default:
        return lower;
    }
  }

  /// Translates [text] into [targetLanguage] (e.g., 'hi' for Hindi).
  /// Returns original text if target language is English ('en') or if request fails.
  static Future<String> translate(String? text, String targetLanguage) async {
    if (text == null || text.trim().isEmpty || targetLanguage.toLowerCase() == 'en') {
      return text ?? '';
    }

    final isoCode = _normalizeLanguageCode(targetLanguage);
    final cleanText = text.trim();
    final cacheKey = '${isoCode}_${cleanText.hashCode}';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$isoCode&dt=t&q=${Uri.encodeComponent(cleanText)}',
      );

      final response = await _client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0] is List) {
          final StringBuffer translatedText = StringBuffer();
          for (var item in data[0]) {
            if (item is List && item.isNotEmpty && item[0] != null) {
              translatedText.write(item[0]);
            }
          }
          final result = translatedText.toString();
          if (result.isNotEmpty) {
            _cache[cacheKey] = result;
            return result;
          }
        }
      }
    } catch (_) {
      // Return original text if offline or timeout
    }
    return text;
  }
}
