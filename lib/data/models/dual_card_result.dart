/// Model for two-card readings (Heartbreak, Divine Magic, Wisdom).
/// These return card1 + card2 with separate text fields.
class DualCardResult {
  final String? card1;
  final String? card2;
  final String? card1Image;
  final String? card2Image;
  final String? cause;
  final String? remedy;
  final String? advise;
  final String? ying;
  final String? yang;

  const DualCardResult({
    this.card1,
    this.card2,
    this.card1Image,
    this.card2Image,
    this.cause,
    this.remedy,
    this.advise,
    this.ying,
    this.yang,
  });

  factory DualCardResult.fromJson(Map<String, dynamic> json) {
    final prediction = json['prediction'] as Map<String, dynamic>? ?? json;

    return DualCardResult(
      card1: prediction['card1'] as String?,
      card2: prediction['card2'] as String?,
      card1Image: prediction['card1_image'] as String?,
      card2Image: prediction['card2_image'] as String?,
      cause: prediction['cause'] as String?,
      remedy: prediction['remedy'] as String?,
      advise: prediction['advise'] as String?,
      ying: prediction['ying'] as String?,
      yang: prediction['yang'] as String?,
    );
  }

  /// All text sections joined for display.
  String get displayText {
    final parts = <String>[];
    if (cause != null && cause!.isNotEmpty) parts.add(cause!);
    if (remedy != null && remedy!.isNotEmpty) parts.add(remedy!);
    if (advise != null && advise!.isNotEmpty) parts.add(advise!);
    if (ying != null && ying!.isNotEmpty) parts.add(ying!);
    if (yang != null && yang!.isNotEmpty) parts.add(yang!);
    return parts.join('\n\n');
  }
}
