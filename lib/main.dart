import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/services/ad_service.dart';
import 'data/services/remote_config_service.dart';
import 'app.dart';
import 'state/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core safely
  try {
    await Firebase.initializeApp();
    // Initialize Firebase Remote Config to fetch dynamic keys
    await RemoteConfigService.initialize();
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  // Validate AI Oracle configuration
  final geminiKey = RemoteConfigService.geminiApiKey;
  final geminiModel = RemoteConfigService.geminiModel;

  debugPrint('🔮 AI Oracle Configuration:');
  debugPrint('   Model: $geminiModel');
  debugPrint('   API Key: ${geminiKey.isNotEmpty ? '✅ Configured' : '❌ Missing'}');

  // Initialize Google Mobile Ads SDK
  await AdService.instance.initialize();

  // Initialize SharedPreferences for language preference
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MysticTarotApp(),
    ),
  );
}
