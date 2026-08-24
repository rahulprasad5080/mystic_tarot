import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static const String _systemInstruction = '''
You are "Mystic Oracle", a wise, intuitive, compassionate, and mystical AI Tarot & Astrological Guide.
Your purpose is to provide spiritual insights, Tarot card interpretations, zodiac compatibility advice, and guidance for life, love, and career questions.

IMPORTANT: If the user mentions a family member's name in brackets [like this], personalize your responses to that specific person. Reference their name and consider their zodiac sign when giving advice. Be warm and specific about them.

Tone: Warm, mystical, empathetic, insightful, and encouraging.
Formatting: Use clear headings, bullet points, and cosmic emojis (✨, 🃏, 🌙, 🔮, 💫) when appropriate. Keep responses concise, engaging, and easy to read.
If the user asks non-spiritual or unrelated technical questions, gently guide them back with mystical wisdom.
''';

  /// Check if Gemini API Key is configured
  bool get isKeyConfigured => _apiKey.trim().isNotEmpty && _apiKey != 'your_gemini_api_key_here';

  String get _modelName => dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.0-flash';

  /// Fallback models to try if primary model fails
  static const List<String> fallbackModels = [
    'gemini-2.0-flash',
    'gemini-1.5-pro',
    'gemini-1.5-flash',
    'gemini-pro-vision',
  ];

  /// Send chat prompt to Gemini API
  Future<String> sendMessage({
    required String prompt,
    List<Map<String, String>> chatHistory = const [],
  }) async {
    if (!isKeyConfigured) {
      return '''
✨ *The Mystic Oracle is awakening...*

To unlock personalized AI Tarot readings and cosmic guidance, please add your **GEMINI_API_KEY** in the `.env` file.

*Tip: You can get a free Gemini API Key from Google AI Studio.*
''';
    }

    try {
      // Build conversation payload for Gemini REST API
      final contents = <Map<String, dynamic>>[];

      // System instruction as initial context
      contents.add({
        'role': 'user',
        'parts': [
          {'text': 'System Context: $_systemInstruction\n\nPlease acknowledge your role as Mystic Oracle.'}
        ]
      });
      contents.add({
        'role': 'model',
        'parts': [
          {'text': 'Greetings, seeker! I am Mystic Oracle, your celestial guide. How may the stars and cards illuminate your path today? ✨🔮'}
        ]
      });

      // Add conversation history
      for (final msg in chatHistory) {
        final role = msg['sender'] == 'user' ? 'user' : 'model';
        contents.add({
          'role': role,
          'parts': [
            {'text': msg['text'] ?? ''}
          ]
        });
      }

      // Add current user prompt
      contents.add({
        'role': 'user',
        'parts': [
          {'text': prompt}
        ]
      });

      final modelPath = _modelName.startsWith('models/') ? _modelName : 'models/$_modelName';
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/$modelPath:generateContent?key=$_apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': contents,
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 1000,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] ?? 'The stars are quiet at this moment.';
          }
        }
        return 'The celestial alignment is shifting. Please ask again.';
      }

      // Enhanced error logging for debugging
      debugPrint('❌ Gemini API Error');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Request URL: ${url.toString()}');
      debugPrint('Model: $_modelName');
      debugPrint('Model Path: $modelPath');
      debugPrint('API Key Present: ${_apiKey.isNotEmpty}');
      debugPrint('Response Body: ${response.body}');

      // User-friendly error messages based on status code
      if (response.statusCode == 401 || response.statusCode == 403) {
        return '🔮 *Authentication failed. Please verify your **GEMINI_API_KEY** in the .env file.*';
      } else if (response.statusCode == 404) {
        return '🔮 *Invalid model name: $_modelName. Try: **gemini-1.5-flash**, **gemini-1.5-pro**, or **gemini-2.0-flash***';
      } else if (response.statusCode == 400) {
        return '🔮 *Bad request. Model: $_modelName may not be available. Try **gemini-1.5-flash** instead.*';
      } else if (response.statusCode == 429) {
        return '⏳ *API rate limit exceeded. Please try again in a moment.* ✨';
      }

      return '🔮 *The cosmic connection was interrupted (Error ${response.statusCode}). Try updating GEMINI_MODEL in .env.*';
    } catch (e) {
      debugPrint('❌ Gemini API Exception: $e');
      return '✨ *The cosmic energy fluctuated: ${e.toString()}*';
    }
  }

  /// Analyze reading result with AI for deeper insights
  Future<String> analyzeReading({
    required String readingTitle,
    required String predictionText,
    String? question,
    String? cardName,
  }) async {
    final prompt = '''
Reading Type: $readingTitle
${question != null && question.isNotEmpty ? 'User Question: "$question"' : ''}
${cardName != null && cardName.isNotEmpty ? 'Card Drawn: $cardName' : ''}
Prediction: $predictionText

Provide a deeper, personalized AI Tarot interpretation for this reading:
1. ✨ Key Spiritual Meaning & Hidden Insights
2. 💫 Actionable Advice for the Seeker
3. 🌙 Cosmic Affirmation for Today
''';

    return await sendMessage(prompt: prompt);
  }

  /// Configuration Limits
  static const int maxOutputTokens = 1000;
  static const int freeDailyQuestionLimit = 1;
  static const int subscriberDailyQuestionLimit = 10;
  static const int freeMaxPromptCharacters = 500;

  /// Helper to verify if user phone number is from India (+91)
  static bool isIndianPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) return false;
    final clean = phoneNumber.replaceAll(RegExp(r'\s+|-|\('), '');
    return clean.startsWith('+91') || (clean.length == 10 && RegExp(r'^[6-9]').hasMatch(clean));
  }

  /// Check character limit for user prompt (500 chars for free tier)
  static bool validatePromptLength(String prompt, {bool isSubscribed = false}) {
    if (isSubscribed) return true; // Subscribers get full prompt limit
    return prompt.trim().length <= freeMaxPromptCharacters;
  }

  /// Get allowed daily question count for user
  static int getDailyLimit({bool isSubscribed = false}) {
    return isSubscribed ? subscriberDailyQuestionLimit : freeDailyQuestionLimit;
  }

  /// List available models (for debugging)
  Future<List<String>> listAvailableModels() async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models?key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['models'] as List?;
        if (models != null) {
          final modelNames = models
              .map((m) => (m['name'] as String?)?.replaceFirst('models/', '') ?? '')
              .where((name) => name.isNotEmpty && name.contains('gemini'))
              .toList();
          debugPrint('✅ Available Gemini models: $modelNames');
          return modelNames;
        }
      }
      debugPrint('❌ Could not list models. Status: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Error listing models: $e');
      return [];
    }
  }
}


