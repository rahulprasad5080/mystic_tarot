import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Provider for SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

/// Provider for the current locale.
final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

/// Provider to check if this is the first launch.
final isFirstLaunchProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(AppConstants.prefFirstLaunch) ?? true;
});

/// Notifier that manages the app's locale state.
class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs)
      : super(Locale(_prefs.getString(AppConstants.prefLocale) ?? 'en'));

  /// Set a new locale and persist it.
  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await _prefs.setString(AppConstants.prefLocale, languageCode);
    await _prefs.setBool(AppConstants.prefFirstLaunch, false);
  }

  /// Get the current language code for API calls.
  String get languageCode => state.languageCode;
}
