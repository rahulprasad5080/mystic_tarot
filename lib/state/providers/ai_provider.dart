import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/ai_service.dart';

class ChatMessage {
  final String id;
  final String text;
  final String sender; // 'user' or 'ai'
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isError = false,
  });
}

class AIChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  AIChatState({
    required this.messages,
    this.isLoading = false,
    this.errorMessage,
  });

  AIChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AIChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

class AIChatNotifier extends StateNotifier<AIChatState> {
  final AIService _aiService;

  AIChatNotifier(this._aiService)
      : super(AIChatState(
          messages: [
            ChatMessage(
              id: 'welcome',
              text:
                  'Greetings, seeker! ✨ I am **Mystic Oracle**, your AI Tarot & Celestial Guide.\n\nAsk me anything about your Tarot readings, daily horoscope, love compatibility, or life guidance. 🔮',
              sender: 'ai',
              timestamp: DateTime.now(),
            ),
          ],
        ));

  Future<void> sendMessage(String text, {bool isSubscribed = false}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    // Secure Daily Limit Check via SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final key = 'ai_questions_count_$todayStr';
    final currentCount = prefs.getInt(key) ?? 0;
    final maxLimit = AIService.getDailyLimit(isSubscribed: isSubscribed);

    if (currentCount >= maxLimit) {
      final limitMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: isSubscribed
            ? '✨ You have reached your daily limit of $maxLimit questions. The stars will reset tomorrow! 🌙'
            : '🔮 You have used your 1 free daily question. Please subscribe to ask up to 10 questions daily! ✨',
        sender: 'ai',
        timestamp: DateTime.now(),
      );
      state = state.copyWith(messages: [...state.messages, limitMsg]);
      return;
    }

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      sender: 'user',
      timestamp: DateTime.now(),
    );

    // Append user message and set loading
    final updatedMessages = [...state.messages, userMsg];
    state = state.copyWith(
      messages: updatedMessages,
      isLoading: true,
      errorMessage: null,
    );

    // Format chat history for API (cap last 6 messages to avoid token bloat & injection)
    final history = state.messages
        .where((m) => m.id != 'welcome' && !m.isError)
        .toList();
    final recentHistory = (history.length > 6 ? history.sublist(history.length - 6) : history)
        .map((m) => {'sender': m.sender, 'text': m.text})
        .toList();

    final response = await _aiService.sendMessage(
      prompt: trimmed,
      chatHistory: recentHistory,
    );

    final isErrorRes = response.contains('interrupted') || response.contains('Error') || response.contains('fluctuated');

    if (!isErrorRes) {
      // Increment daily usage count upon successful attempt
      await prefs.setInt(key, currentCount + 1);
    }

    final aiMsg = ChatMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: response,
      sender: 'ai',
      timestamp: DateTime.now(),
      isError: isErrorRes,
    );

    state = state.copyWith(
      messages: [...state.messages, aiMsg],
      isLoading: false,
    );
  }

  void retryLastMessage() {
    final userMsgs = state.messages.where((m) => m.sender == 'user').toList();
    if (userMsgs.isNotEmpty) {
      final lastUserText = userMsgs.last.text;
      // Remove last AI error message if present
      if (state.messages.isNotEmpty && (state.messages.last.isError || state.messages.last.text.contains('interrupted'))) {
        final updated = List<ChatMessage>.from(state.messages)..removeLast();
        state = state.copyWith(messages: updated);
      }
      sendMessage(lastUserText);
    }
  }

  void clearChat() {
    state = AIChatState(
      messages: [
        ChatMessage(
          id: 'welcome',
          text:
              'Greetings, seeker! ✨ I am **Mystic Oracle**, your AI Tarot & Celestial Guide.\n\nAsk me anything about your Tarot readings, daily horoscope, love compatibility, or life guidance. 🔮',
          sender: 'ai',
          timestamp: DateTime.now(),
        ),
      ],
    );
  }
}

final aiChatProvider = StateNotifierProvider<AIChatNotifier, AIChatState>((ref) {
  final aiService = ref.watch(aiServiceProvider);
  return AIChatNotifier(aiService);
});
