import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Firebase Remote Config service for dynamically managing API keys and settings remotely.
class RemoteConfigService {
  RemoteConfigService._();

  static FirebaseRemoteConfig? _remoteConfig;

  /// Initialize Firebase Remote Config and fetch remote parameters.
  static Future<void> initialize() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? const Duration(seconds: 10)
              : const Duration(hours: 1),
        ),
      );

      await _remoteConfig!.fetchAndActivate();
      debugPrint('Firebase Remote Config initialized and parameters activated!');
    } catch (e) {
      debugPrint('Error initializing Firebase Remote Config: $e');
    }
  }

  /// Get string config value from Firebase Remote Config
  static String _getString(String key, {String defaultValue = ''}) {
    try {
      if (_remoteConfig != null) {
        final val = _remoteConfig!.getString(key);
        if (val.isNotEmpty) {
          return val;
        }
      }
    } catch (_) {}
    return defaultValue;
  }

  // --- Public Configuration Getters ---

  static String get divineApiKey => _getString('DIVINE_API_KEY');

  static String get divineApiAuthToken {
    final token = _getString('DIVINE_API_AUTH_TOKEN');
    return token.isNotEmpty ? token : divineApiKey;
  }

  static String get divineApiBaseUrl => _getString('DIVINE_API_BASE_URL');

  static bool get enableTranslator {
    final val = _getString('DIVINE_API_ENABLE_TRANSLATOR', defaultValue: 'true');
    return val.toLowerCase() == 'true';
  }

  static String get geminiApiKey => _getString('GEMINI_API_KEY');

  static String get geminiModel => _getString('GEMINI_MODEL');

  static String get razorpayKeyId => _getString('RAZORPAY_KEY_ID');

  static String get admobAppId => _getString('ADMOB_APP_ID');

  static String get admobNativeAdUnitId => _getString('ADMOB_NATIVE_AD_UNIT_ID');

  static String get admobInterstitialAdUnitId =>
      _getString('ADMOB_INTERSTITIAL_AD_UNIT_ID');
}
