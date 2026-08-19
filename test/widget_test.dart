import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_tarot/data/models/api_response.dart';
import 'package:mystic_tarot/data/models/reading_result.dart';
import 'package:mystic_tarot/core/constants/reading_types.dart';

void main() {
  group('ReadingTypes Tests', () {
    test('Should have 20 primary reading types', () {
      expect(ReadingTypes.all.length, equals(20));
    });

    test('All reading types should have valid endpoints', () {
      for (final type in ReadingTypes.all) {
        expect(type.endpoint, startsWith('/api/'));
        expect(type.id, isNotEmpty);
      }
    });

    test('Should have zero duplicate IDs or endpoints', () {
      final ids = ReadingTypes.all.map((r) => r.id).toList();
      final endpoints = ReadingTypes.all.map((r) => r.endpoint).toList();

      expect(ids.length, equals(ids.toSet().length), reason: 'Duplicate ID found in ReadingTypes');
      expect(endpoints.length, equals(endpoints.toSet().length), reason: 'Duplicate endpoint found in ReadingTypes');
    });

    test('Filter by category returns expected subset', () {
      final tarotReadings = ReadingTypes.byCategory(ReadingCategory.tarot);
      expect(tarotReadings, isNotEmpty);
      for (final r in tarotReadings) {
        expect(r.category, equals(ReadingCategory.tarot));
      }
    });
  });

  group('ApiResponse Model Tests', () {
    test('ApiResponse parses success correctly', () {
      final json = {
        'success': 1,
        'data': {
          'prediction': {
            'card': 'THE FOOL',
            'result': 'New beginnings await you.'
          }
        }
      };

      final response = ApiResponse.fromJson(json, ReadingResult.fromJson);
      expect(response.isSuccess, isTrue);
      expect(response.data?.card, equals('THE FOOL'));
      expect(response.data?.displayText, equals('New beginnings await you.'));
    });

    test('ApiResponse handles auth error correctly', () {
      final json = {
        'success': 3,
        'msg': 'Invalid authorization token!'
      };

      final response = ApiResponse.fromJson(json, ReadingResult.fromJson);
      expect(response.isSuccess, isFalse);
      expect(response.isAuthError, isTrue);
      expect(response.message, equals('Invalid authorization token!'));
    });
  });
}
