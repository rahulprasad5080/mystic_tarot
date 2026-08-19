import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/api_response.dart';
import '../../data/repositories/reading_repository.dart';
import '../../core/constants/reading_types.dart';
import 'locale_provider.dart';

/// Provider for the reading repository singleton.
final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return ReadingRepository();
});

/// Parameters for a reading request.
class ReadingParams {
  final ReadingType readingType;
  final String? cardImage;
  final String? sign1;
  final String? sign2;
  final String? sign;

  const ReadingParams({
    required this.readingType,
    this.cardImage,
    this.sign1,
    this.sign2,
    this.sign,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingParams &&
          runtimeType == other.runtimeType &&
          readingType.id == other.readingType.id &&
          cardImage == other.cardImage &&
          sign1 == other.sign1 &&
          sign2 == other.sign2 &&
          sign == other.sign;

  @override
  int get hashCode =>
      readingType.id.hashCode ^
      cardImage.hashCode ^
      sign1.hashCode ^
      sign2.hashCode ^
      sign.hashCode;
}

/// FutureProvider.family for fetching a reading.
/// Each unique ReadingParams key gets its own cached result.
/// Auto-disposed when no longer watched.
final readingProvider =
    FutureProvider.autoDispose.family<ApiResponse<dynamic>, ReadingParams>(
  (ref, params) async {
    final repository = ref.watch(readingRepositoryProvider);
    final locale = ref.watch(localeProvider);

    return repository.getReading(
      readingType: params.readingType,
      language: locale.languageCode,
      cardImage: params.cardImage,
      sign1: params.sign1,
      sign2: params.sign2,
      sign: params.sign,
    );
  },
);

