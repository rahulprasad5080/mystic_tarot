import '../../core/utils/json_utils.dart';

/// Model for Love Triangle Reading result.
/// Returns 3 cards with perspectives: your view, lover1, lover2.
class LoveTriangleResult {
  final String? card1;
  final String? card2;
  final String? card3;
  final String? card1Image;
  final String? card2Image;
  final String? card3Image;
  final String? your;
  final String? lover1;
  final String? lover2;

  const LoveTriangleResult({
    this.card1,
    this.card2,
    this.card3,
    this.card1Image,
    this.card2Image,
    this.card3Image,
    this.your,
    this.lover1,
    this.lover2,
  });

  factory LoveTriangleResult.fromJson(Map<String, dynamic> json) {
    final rawPred = json['prediction'];
    final Map<String, dynamic> prediction = rawPred is Map
        ? JsonUtils.parseMap(rawPred)
        : json;

    return LoveTriangleResult(
      card1: JsonUtils.parseString(prediction['card1'] ?? json['card1']),
      card2: JsonUtils.parseString(prediction['card2'] ?? json['card2']),
      card3: JsonUtils.parseString(prediction['card3'] ?? json['card3']),
      card1Image: JsonUtils.parseString(prediction['card1_image'] ?? json['card1_image']),
      card2Image: JsonUtils.parseString(prediction['card2_image'] ?? json['card2_image']),
      card3Image: JsonUtils.parseString(prediction['card3_image'] ?? json['card3_image']),
      your: JsonUtils.parseString(prediction['your'] ?? json['your']),
      lover1: JsonUtils.parseString(prediction['lover1'] ?? json['lover1']),
      lover2: JsonUtils.parseString(prediction['lover2'] ?? json['lover2']),
    );
  }
}

/// Model for Fortune Cookie result.
class FortuneCookieResult {
  final String? result;

  const FortuneCookieResult({this.result});

  factory FortuneCookieResult.fromJson(Map<String, dynamic> json) {
    final rawPred = json['prediction'];
    final Map<String, dynamic> prediction = rawPred is Map
        ? JsonUtils.parseMap(rawPred)
        : json;

    return FortuneCookieResult(
      result: JsonUtils.parseString(prediction['result'] ?? json['result']),
    );
  }
}
