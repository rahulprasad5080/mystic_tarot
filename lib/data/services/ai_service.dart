import 'dart:convert';
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
Tone: Warm, mystical, empathetic, insightful, and encouraging.
Formatting: Use clear headings, bullet points, and cosmic emojis (✨, 🃏, 🌙, 🔮, 💫) when appropriate. Keep responses concise, engaging, and easy to read.
If the user asks non-spiritual or unrelated technical questions, gently guide them back with mystical wisdom.
''';

  /// Check if Gemini API Key is configured
  bool get isKeyConfigured => _apiKey.trim().isNotEmpty && _apiKey != 'your_gemini_api_key_here';

  String get _modelName => dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.5-flash-lite';

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

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$_modelName:generateContent?key=$_apiKey',
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

      return '🔮 *The cosmic connection was interrupted (Error ${response.statusCode}). Please check your API key or network.*';
    } catch (e) {
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
}


