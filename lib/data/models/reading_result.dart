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
    final prediction = json['prediction'] as Map<String, dynamic>?;
    if (prediction == null) {
      // Some endpoints put data directly (e.g. daily tarot)
      return ReadingResult(
        card: json['card'] as String?,
        category: json['category'] as String?,
        result: json['result'] as String?,
        career: json['career'] as String?,
        love: json['love'] as String?,
        finance: json['finance'] as String?,
        image: json['image'] as String?,
        image2: json['image2'] as String?,
        image3: json['image3'] as String?,
        cardImage: json['card_image'] as String?,
      );
    }

    return ReadingResult(
      card: prediction['card'] as String?,
      category: prediction['category'] as String?,
      yesNo: prediction['yes_no'] as String?,
      result: prediction['result'] as String?,
      career: prediction['career'] as String?,
      love: prediction['love'] as String?,
      finance: prediction['finance'] as String?,
      image: prediction['image'] as String?,
      image2: prediction['image2'] as String?,
      image3: prediction['image3'] as String?,
      cardImage: prediction['card_image'] as String?,
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
