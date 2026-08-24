import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/services/ad_service.dart';
import 'data/services/ai_service.dart';
import 'app.dart';
import 'state/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env file)
  try {
    await dotenv.load(fileName: '.env');

    // Validate Gemini API setup
    final geminiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    final geminiModel = dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.0-flash';

    debugPrint('🔮 AI Oracle Configuration:');
    debugPrint('   Model: $geminiModel');
    debugPrint('   API Key: ${geminiKey.isNotEmpty ? '✅ Configured' : '❌ Missing'}');

    if (geminiKey.isEmpty || geminiKey == 'your_gemini_api_key_here') {
      debugPrint('   ⚠️  WARNING: GEMINI_API_KEY is not properly configured!');
    }

    if (geminiModel == 'gemini-2.5-flash-lite') {
      debugPrint('   ⚠️  WARNING: Invalid model name "gemini-2.5-flash-lite" - use "gemini-2.0-flash"');
    }

    // List available models for debugging
    if (geminiKey.isNotEmpty && geminiKey != 'your_gemini_api_key_here') {
      debugPrint('\n📋 Checking available Gemini models...');
      await AIService().listAvailableModels();
    }
  } catch (e) {
    debugPrint('Warning: .env file not found or failed to load: $e');
  }

  // Initialize Firebase Core safely
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

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
