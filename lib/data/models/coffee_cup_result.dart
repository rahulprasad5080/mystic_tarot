import '../../core/utils/json_utils.dart';

/// Model for Coffee Cup Reading result.
/// Returns 3 positions: present, near future, distant future.
class CoffeeCupResult {
  final String? presentTitle;
  final String? presentImage;
  final String? presentContent;
  final String? nearFutureTitle;
  final String? nearFutureImage;
  final String? nearFutureContent;
  final String? distantFutureTitle;
  final String? distantFutureImage;
  final String? distantFutureContent;

  const CoffeeCupResult({
    this.presentTitle,
    this.presentImage,
    this.presentContent,
    this.nearFutureTitle,
    this.nearFutureImage,
    this.nearFutureContent,
    this.distantFutureTitle,
    this.distantFutureImage,
    this.distantFutureContent,
  });

  factory CoffeeCupResult.fromJson(Map<String, dynamic> json) {
    final rawPred = json['prediction'];
    final Map<String, dynamic> prediction = rawPred is Map
        ? JsonUtils.parseMap(rawPred)
        : json;

    return CoffeeCupResult(
      presentTitle: JsonUtils.parseString(prediction['present_title'] ?? json['present_title']),
      presentImage: JsonUtils.parseString(prediction['present_image'] ?? json['present_image']),
      presentContent: JsonUtils.parseString(prediction['present_content'] ?? json['present_content']),
      nearFutureTitle: JsonUtils.parseString(prediction['near_future_title'] ?? json['near_future_title']),
      nearFutureImage: JsonUtils.parseString(prediction['near_future_image'] ?? json['near_future_image']),
      nearFutureContent: JsonUtils.parseString(prediction['near_future_content'] ?? json['near_future_content']),
      distantFutureTitle: JsonUtils.parseString(prediction['distant_future_title'] ?? json['distant_future_title']),
      distantFutureImage: JsonUtils.parseString(prediction['distant_future_image'] ?? json['distant_future_image']),
      distantFutureContent: JsonUtils.parseString(prediction['distant_future_content'] ?? json['distant_future_content']),
    );
  }
}
