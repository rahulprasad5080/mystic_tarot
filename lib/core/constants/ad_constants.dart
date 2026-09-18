import '../../data/services/remote_config_service.dart';

/// Centralized AdMob credentials and Ad Unit IDs, dynamically powered by Firebase Remote Config.
class AdConstants {
  AdConstants._();

  /// Google AdMob App ID
  static String get appId => RemoteConfigService.admobAppId;

  /// Native Video Ad Unit ID
  static String get nativeAdUnitId => RemoteConfigService.admobNativeAdUnitId;

  /// Interstitial Ad Unit ID
  static String get interstitialAdUnitId =>
      RemoteConfigService.admobInterstitialAdUnitId;
}
