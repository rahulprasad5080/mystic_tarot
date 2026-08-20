import '../../core/utils/json_utils.dart';

/// Generic model for single-card reading results.
/// Used by: Yes/No Tarot, Daily Tarot, Career Reading, Divine Angel,
/// Dream Come True, Egyptian, Erotic Love, Ex-Flame, Flirt Love,
/// In-Depth Love, Know Your Friend, Made For Each Other, Power Life,
/// Past Lives Connection.
class ReadingResult {
  final String? card;
  final String? category;
  final String? yesNo;
  final String? result;
  final String? career;
  final String? love;
  final String? finance;
  final String? image;
  final String? image2;
  final String? image3;
  final String? cardImage;

  const ReadingResult({
    this.card,
    this.category,
    this.yesNo,
    this.result,
    this.career,
    this.love,
    this.finance,
    this.image,
    this.image2,
    this.image3,
    this.cardImage,
  });

  factory ReadingResult.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> cardData = {};
    final rawCards = json['cards'];
    if (rawCards is List && rawCards.isNotEmpty && rawCards.first is Map) {
      cardData = JsonUtils.parseMap(rawCards.first);
    }

    final rawPred = json['prediction'];
    final Map<String, dynamic> dataMap = rawPred is Map
        ? JsonUtils.parseMap(rawPred)
        : json;

    return ReadingResult(
      card: JsonUtils.parseString(cardData['card'] ?? dataMap['card'] ?? json['card']),
      category: JsonUtils.parseString(cardData['category'] ?? dataMap['category'] ?? json['category']),
      yesNo: JsonUtils.parseString(cardData['yes_no'] ?? dataMap['yes_no'] ?? json['yes_no']),
      result: JsonUtils.parseString(cardData['result'] ?? dataMap['result'] ?? json['result']),
      career: JsonUtils.parseString(cardData['career'] ?? dataMap['career'] ?? json['career']),
      love: JsonUtils.parseString(cardData['love'] ?? dataMap['love'] ?? json['love']),
      finance: JsonUtils.parseString(cardData['finance'] ?? dataMap['finance'] ?? json['finance']),
      image: JsonUtils.parseString(cardData['image'] ?? dataMap['image'] ?? json['image']),
      image2: JsonUtils.parseString(cardData['image2'] ?? dataMap['image2'] ?? json['image2']),
      image3: JsonUtils.parseString(cardData['image3'] ?? dataMap['image3'] ?? json['image3']),
      cardImage: JsonUtils.parseString(cardData['card_image'] ?? dataMap['card_image'] ?? json['card_image']),
    );
  }

  /// The primary text content to display.
  String get displayText {
    if (result != null && result!.isNotEmpty) return result!;
    if (career != null && career!.isNotEmpty) return career!;
    if (love != null && love!.isNotEmpty) return love!;
    return '';
  }

  /// The primary image URL to display.
  String? get displayImage => image ?? image2 ?? image3 ?? cardImage;

  /// Whether this reading has a Yes/No answer.
  bool get hasYesNo => yesNo != null && yesNo!.isNotEmpty;
}
