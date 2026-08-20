import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service providing fast, free translation via Google Translate GTX endpoint.
class TranslationService {
  static final http.Client _client = http.Client();
  static final Map<String, String> _cache = {};

  /// Translates [text] into [targetLanguage] (e.g., 'hi' for Hindi).
  /// Returns original text if target language is English ('en') or if request fails.
  static Future<String> translate(String? text, String targetLanguage) async {
    if (text == null || text.trim().isEmpty || targetLanguage.toLowerCase() == 'en') {
      return text ?? '';
    }

    final cleanText = text.trim();
    final cacheKey = '${targetLanguage}_${cleanText.hashCode}';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$targetLanguage&dt=t&q=${Uri.encodeComponent(cleanText)}',
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
