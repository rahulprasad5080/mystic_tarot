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
    final prediction = json['prediction'] as Map<String, dynamic>? ?? json;

    return LoveTriangleResult(
      card1: prediction['card1'] as String?,
      card2: prediction['card2'] as String?,
      card3: prediction['card3'] as String?,
      card1Image: prediction['card1_image'] as String?,
      card2Image: prediction['card2_image'] as String?,
      card3Image: prediction['card3_image'] as String?,
      your: prediction['your'] as String?,
      lover1: prediction['lover1'] as String?,
      lover2: prediction['lover2'] as String?,
    );
  }
}

/// Model for Fortune Cookie result.
class FortuneCookieResult {
  final String? result;

  const FortuneCookieResult({this.result});

  factory FortuneCookieResult.fromJson(Map<String, dynamic> json) {
    final prediction = json['prediction'] as Map<String, dynamic>? ?? json;
    return FortuneCookieResult(
      result: prediction['result'] as String?,
    );
  }
}
