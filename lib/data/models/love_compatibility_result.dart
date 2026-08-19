import '../../core/utils/json_utils.dart';

/// Model for Love Compatibility result.
class LoveCompatibilityResult {
  final String? sign1;
  final String? sign2;
  final String? overallCompatibility;
  final String? positiveAspects;
  final String? negativeAspects;
  final String? elements;
  final String? idealDate;
  final CompatibilityScore? score;

  const LoveCompatibilityResult({
    this.sign1,
    this.sign2,
    this.overallCompatibility,
    this.positiveAspects,
    this.negativeAspects,
    this.elements,
    this.idealDate,
    this.score,
  });

  factory LoveCompatibilityResult.fromJson(Map<String, dynamic> json) {
    final rawPred = json['prediction'];
    final Map<String, dynamic> prediction = rawPred is Map
        ? JsonUtils.parseMap(rawPred)
        : json;

    final rawScore = prediction['score'] ?? json['score'];

    return LoveCompatibilityResult(
      sign1: JsonUtils.parseString(prediction['sign_1'] ?? json['sign_1']),
      sign2: JsonUtils.parseString(prediction['sign_2'] ?? json['sign_2']),
      overallCompatibility: JsonUtils.parseString(prediction['overall_compatibility'] ?? json['overall_compatibility']),
      positiveAspects: JsonUtils.parseString(prediction['positive_aspects'] ?? json['positive_aspects']),
      negativeAspects: JsonUtils.parseString(prediction['negative_aspects'] ?? json['negative_aspects']),
      elements: JsonUtils.parseString(prediction['elements'] ?? json['elements']),
      idealDate: JsonUtils.parseString(prediction['ideal_date'] ?? json['ideal_date']),
      score: rawScore is Map ? CompatibilityScore.fromJson(JsonUtils.parseMap(rawScore)) : null,
    );
  }
}

class CompatibilityScore {
  final String? general;
  final String? communication;
  final String? sex;

  const CompatibilityScore({this.general, this.communication, this.sex});

  factory CompatibilityScore.fromJson(Map<String, dynamic> json) {
    return CompatibilityScore(
      general: JsonUtils.parseString(json['general']),
      communication: JsonUtils.parseString(json['communication']),
      sex: JsonUtils.parseString(json['sex']),
    );
  }
}
