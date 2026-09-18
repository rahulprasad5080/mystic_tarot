import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/services/ad_service.dart';
import 'data/services/ai_service.dart';
import 'app.dart';
import 'state/providers/locale_provider.dart';

import 'data/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env file as fallback)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Warning: .env file not found or failed to load: $e');
  }

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
