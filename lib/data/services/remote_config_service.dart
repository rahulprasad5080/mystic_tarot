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

      // Default values if Remote Config hasn't fetched yet
      const defaults = <String, dynamic>{
        'DIVINE_API_KEY': '',
        'DIVINE_API_AUTH_TOKEN': '',
        'DIVINE_API_BASE_URL': 'https://astroapi-5.divineapi.com',
        'GEMINI_API_KEY': '',
        'GEMINI_MODEL': 'gemini-2.5-flash-lite',
        'RAZORPAY_KEY_ID': 'rzp_test_AblyTarot2026',
        'DIVINE_API_ENABLE_TRANSLATOR': 'true',
      };

      await _remoteConfig!.setDefaults(defaults);
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

  static String get divineApiBaseUrl {
    final url = _getString('DIVINE_API_BASE_URL');
    return url.isNotEmpty ? url : 'https://astroapi-5.divineapi.com';
  }

  static bool get enableTranslator {
    final val = _getString('DIVINE_API_ENABLE_TRANSLATOR', defaultValue: 'true');
    return val.toLowerCase() == 'true';
  }

  static String get geminiApiKey => _getString('GEMINI_API_KEY');

  static String get geminiModel {
    final model = _getString('GEMINI_MODEL');
    return model.isNotEmpty ? model : 'gemini-2.5-flash-lite';
  }

  static String get razorpayKeyId {
    final key = _getString('RAZORPAY_KEY_ID');
    return key.isNotEmpty ? key : 'rzp_test_AblyTarot2026';
  }
}
