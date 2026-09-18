import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RegionType { india, global }

/// Service to detect whether the user is located in India or globally.
/// Used to select Razorpay (India) vs Google Play Payments (Global).
class RegionService {
  static const String _prefRegionKey = 'user_selected_region';

  /// Detects the user region based on device locale, timezone offset, or saved preference.
  static Future<RegionType> getRegion() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRegion = prefs.getString(_prefRegionKey);
    if (savedRegion != null) {
      return savedRegion == 'india' ? RegionType.india : RegionType.global;
    }

    try {
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      final countryCode = locale.countryCode?.toUpperCase();
      if (countryCode == 'IN') {
        return RegionType.india;
      }

      final now = DateTime.now();
      final offsetHours = now.timeZoneOffset.inMinutes / 60.0;
      final timeZoneName = now.timeZoneName.toUpperCase();

      // India Standard Time offset is +5:30 (5.5) or IST
      if (offsetHours == 5.5 || timeZoneName == 'IST' || timeZoneName.contains('KOLKATA')) {
        return RegionType.india;
      }
    } catch (e) {
      debugPrint('Error detecting region: $e');
    }

    return RegionType.global;
  }

  /// Manually override or save user region preference.
  static Future<void> setRegion(RegionType region) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefRegionKey, region == RegionType.india ? 'india' : 'global');
  }
}
