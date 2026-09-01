import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_constants.dart';

/// Service for managing Google AdMob Ads (Interstitial & Native/Banner).
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  DateTime? _lastInterstitialShownTime;
  Duration interstitialCooldown = const Duration(minutes: 5);

  /// Configure the interstitial ad cooldown duration (default is 5 minutes).
  void setInterstitialCooldown(Duration duration) {
    interstitialCooldown = duration;
  }

  /// Check if the cooldown period has passed since the last interstitial ad.
  bool get canShowInterstitial {
    if (_lastInterstitialShownTime == null) return true;
    return DateTime.now().difference(_lastInterstitialShownTime!) >= interstitialCooldown;
  }

  /// Initialize Mobile Ads SDK.
  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      loadInterstitialAd();
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }

  /// Preload an Interstitial Ad.
  void loadInterstitialAd() {
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AdConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          debugPrint('AdMob Interstitial Ad loaded successfully.');
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
          debugPrint('AdMob Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  /// Show Interstitial Ad when user opens an AI Reading option, enforcing frequency capping.
  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    if (canShowInterstitial && _interstitialAd != null) {
      _lastInterstitialShownTime = DateTime.now();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd(); // Reload for next time
          onAdDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd();
          onAdDismissed();
        },
      );
      _interstitialAd!.show();
    } else {
      // Frequency capped (within 5 minutes) or ad not ready - proceed directly without showing ad
      if (_interstitialAd == null && canShowInterstitial) {
        loadInterstitialAd();
      }
      onAdDismissed();
    }
  }

  /// Create Native Video Ad instance with production Ad Unit ID.
  NativeAd createNativeVideoAd({
    required String factoryId,
    required NativeAdListener listener,
  }) {
    return NativeAd(
      adUnitId: AdConstants.nativeAdUnitId,
      factoryId: factoryId,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        videoOptions: VideoOptions(
          startMuted: true,
          clickToExpandRequested: true,
        ),
      ),
      listener: listener,
    );
  }
}
