import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/ad_constants.dart';

/// Service for managing Google AdMob Ads (Interstitial & Native/Banner).
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

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

  /// Show Interstitial Ad when user opens an AI Reading option, then execute callback.
  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    if (_interstitialAd != null) {
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
      // Ad was not ready, proceed directly
      loadInterstitialAd();
      onAdDismissed();
    }
  }
}
