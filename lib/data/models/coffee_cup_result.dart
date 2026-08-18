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
    final prediction = json['prediction'] as Map<String, dynamic>? ?? json;

    return CoffeeCupResult(
      presentTitle: prediction['present_title'] as String?,
      presentImage: prediction['present_image'] as String?,
      presentContent: prediction['present_content'] as String?,
      nearFutureTitle: prediction['near_future_title'] as String?,
      nearFutureImage: prediction['near_future_image'] as String?,
      nearFutureContent: prediction['near_future_content'] as String?,
      distantFutureTitle: prediction['distant_future_title'] as String?,
      distantFutureImage: prediction['distant_future_image'] as String?,
      distantFutureContent: prediction['distant_future_content'] as String?,
    );
  }
}
