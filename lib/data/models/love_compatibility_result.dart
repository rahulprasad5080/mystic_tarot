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
    final prediction = json['prediction'] as Map<String, dynamic>? ?? json;

    return LoveCompatibilityResult(
      sign1: prediction['sign_1'] as String?,
      sign2: prediction['sign_2'] as String?,
      overallCompatibility: prediction['overall_compatibility'] as String?,
      positiveAspects: prediction['positive_aspects'] as String?,
      negativeAspects: prediction['negative_aspects'] as String?,
      elements: prediction['elements'] as String?,
      idealDate: prediction['ideal_date'] as String?,
      score: prediction['score'] != null
          ? CompatibilityScore.fromJson(
              prediction['score'] as Map<String, dynamic>)
          : null,
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
      general: json['general']?.toString(),
      communication: json['communication']?.toString(),
      sex: json['sex']?.toString(),
    );
  }
}
