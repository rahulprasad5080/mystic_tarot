import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_tarot/core/constants/api_constants.dart';

void main() {
  group('DivineAPI Language Resolution Tests', () {
    test('English language returns English host and exact lan code', () {
      final code = ApiConstants.resolveLanguageCode('en');
      final host = ApiConstants.getHostForLanguage('en');
      expect(code, equals('en'));
      expect(host, equals('https://astroapi-5.divineapi.com'));
    });

    test('Hindi language returns translator host and hi lan code', () {
      final code = ApiConstants.resolveLanguageCode('hi');
      final host = ApiConstants.getHostForLanguage('hi');
      expect(code, equals('hi'));
      expect(host, equals('https://astroapi-5-translator.divineapi.com'));
    });

    test('All 25 DivineAPI language codes are supported and route to correct hosts', () {
      final codes = [
        'en', 'hi', 'zh', 'ja', 'ar',
        'ru', 'pt', 'es', 'fr', 'de',
        'it', 'nl', 'pl', 'tr', 'uk',
        'hu', 'gr', 'bn', 'ma', 'tm',
        'tl', 'ml', 'kn', 'ta', 'bah',
      ];

      for (final c in codes) {
        final resolved = ApiConstants.resolveLanguageCode(c);
        final host = ApiConstants.getHostForLanguage(c);
        expect(resolved, equals(c));
        if (c == 'en') {
          expect(host, equals('https://astroapi-5.divineapi.com'));
        } else {
          expect(host, equals('https://astroapi-5-translator.divineapi.com'));
        }
      }
    });

    test('ISO code mapping works correctly for Greek, Marathi, Tamil, Telugu, Filipino, Indonesian', () {
      expect(ApiConstants.resolveLanguageCode('el'), equals('gr'));
      expect(ApiConstants.resolveLanguageCode('mr'), equals('ma'));
      expect(ApiConstants.resolveLanguageCode('te'), equals('tl'));
      expect(ApiConstants.resolveLanguageCode('id'), equals('bah'));

      // Greek ('el' -> 'gr') host check
      expect(ApiConstants.getHostForLanguage('el'), equals('https://astroapi-5-translator.divineapi.com'));
    });

    test('Unsupported, null, or empty language code falls back to en', () {
      expect(ApiConstants.resolveLanguageCode(null), equals('en'));
      expect(ApiConstants.resolveLanguageCode(''), equals('en'));
      expect(ApiConstants.resolveLanguageCode('   '), equals('en'));
      expect(ApiConstants.resolveLanguageCode('unsupported_code'), equals('en'));

      expect(ApiConstants.getHostForLanguage(null), equals('https://astroapi-5.divineapi.com'));
      expect(ApiConstants.getHostForLanguage('unsupported_code'), equals('https://astroapi-5.divineapi.com'));
    });
  });
}
