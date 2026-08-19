import '../../core/utils/json_utils.dart';

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
    final rawPred = json['prediction'];
    final Map<String, dynamic> prediction = rawPred is Map
        ? JsonUtils.parseMap(rawPred)
        : json;

    return DualCardResult(
      card1: JsonUtils.parseString(prediction['card1'] ?? json['card1']),
      card2: JsonUtils.parseString(prediction['card2'] ?? json['card2']),
      card1Image: JsonUtils.parseString(prediction['card1_image'] ?? json['card1_image']),
      card2Image: JsonUtils.parseString(prediction['card2_image'] ?? json['card2_image']),
      cause: JsonUtils.parseString(prediction['cause'] ?? json['cause']),
      remedy: JsonUtils.parseString(prediction['remedy'] ?? json['remedy']),
      advise: JsonUtils.parseString(prediction['advise'] ?? json['advise']),
      ying: JsonUtils.parseString(prediction['ying'] ?? json['ying']),
      yang: JsonUtils.parseString(prediction['yang'] ?? json['yang']),
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
