import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../state/providers/ai_provider.dart';
import '../../state/providers/auth_provider.dart';
import '../../state/providers/subscription_provider.dart';
import '../../data/services/ai_service.dart';
import '../../data/services/user_profile_service.dart';
import '../../data/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/subscription_sheet.dart';

class AIOracleScreen extends ConsumerStatefulWidget {
  const AIOracleScreen({super.key});

  @override
  ConsumerState<AIOracleScreen> createState() => _AIOracleScreenState();
}

class _AIOracleScreenState extends ConsumerState<AIOracleScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    '✨ Daily Cosmic Insight',
    '💙 Love & Relationship',
    '💼 Career Guidance',
    '🃏 Tarot Message',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        try {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } catch (e) {
          debugPrint('Scroll error: $e');
        }
      }
    });
  }

  void _handleSend([String? customText]) {
    final text = customText ?? _controller.text;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final isSubscribed = ref.read(subscriptionProvider).isSubscribed;
    if (!AIService.validatePromptLength(trimmed, isSubscribed: isSubscribed)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Free prompt limit is 500 characters. Subscribe for unlimited length! ✨'),
          backgroundColor: const Color(0xFF006D85),
          action: SnackBarAction(
            label: 'SUBSCRIBE',
            textColor: Colors.amberAccent,
            onPressed: () => SubscriptionSheet.show(context),
          ),
        ),
      );
      return;
    }

    ref.read(aiChatProvider.notifier).sendMessage(trimmed, isSubscribed: isSubscribed);
    if (customText == null) {
      _controller.clear();
    }
    _scrollToBottom();
  }

  Widget _buildFormattedText(String text, TextStyle baseStyle, {Color? boldColor, Color? italicColor}) {
    final List<InlineSpan> spans = [];
    final RegExp regExp = RegExp(r'(\*\*[^*]+\*\*|\*[^*]+\*)');
    int lastIndex = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }
      final String matchedText = match.group(0)!;
      if (matchedText.startsWith('**') && matchedText.endsWith('**')) {
        spans.add(TextSpan(
          text: matchedText.substring(2, matchedText.length - 2),
          style: baseStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: boldColor ?? baseStyle.color,
          ),
        ));
      } else if (matchedText.startsWith('*') && matchedText.endsWith('*')) {
        spans.add(TextSpan(
          text: matchedText.substring(1, matchedText.length - 1),
          style: baseStyle.copyWith(
            fontStyle: FontStyle.italic,
            color: italicColor ?? baseStyle.color,
          ),
        ));
      }
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final user = ref.watch(currentUserProvider);

    ref.listen(aiChatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F8FC),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0F5B7A),
            size: 22,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Divine Readings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F5B7A),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Subscription Plans',
            icon: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFF006D85),
              size: 24,
            ),
            onPressed: () {
              SubscriptionSheet.show(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFBBE3F1),
                    width: 1.5,
                  ),
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: user?.photoURL != null && user!.photoURL!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: user.photoURL!,
                          width: 38,
                          height: 38,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 22,
                            color: Color(0xFF0F5B7A),
                          ),
                        )
                      : (user?.displayName != null &&
                                user!.displayName!.isNotEmpty
                            ? Center(
                                child: Text(
                                  user.displayName![0].toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF0F5B7A),
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 22,
                                color: Color(0xFF0F5B7A),
                              )),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Family Member Selector
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, prefs) {
                if (!prefs.hasData) return const SizedBox.shrink();
                final profileService = UserProfileService(prefs.data!);
                final profiles = profileService.loadProfiles();

                return Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFFFAFBFC),
                  child: Row(
                    children: [
                      const Text(
                        '👤 About: ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5A6E85),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: profiles.length,
                            itemBuilder: (context, index) {
                              final profile = profiles[index];
                              final isSelected = chatState.selectedFamilyMemberId == profile.id;

                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: FilterChip(
                                  selected: isSelected,
                                  label: Text(
                                    profile.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? Colors.white : const Color(0xFF0F5B7A),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  selectedColor: const Color(0xFF006D85),
                                  side: BorderSide(
                                    color: isSelected ? const Color(0xFF006D85) : const Color(0xFFD4E3ED),
                                  ),
                                  onSelected: (_) {
                                    ref.read(aiChatProvider.notifier).setFamilyMemberContext(
                                      memberId: profile.id,
                                      memberName: profile.name,
                                      memberZodiac: profile.zodiacSign,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Reading Context Card (if analyzing a specific reading)
            if (chatState.currentReadingTitle != null)
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF006D85).withValues(alpha: 0.1),
                      const Color(0xFF0F5B7A).withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF006D85).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.info_rounded,
                          size: 16,
                          color: Color(0xFF006D85),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Analyzing Your Reading',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006D85),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '📖 ${chatState.currentReadingTitle}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F5B7A),
                      ),
                    ),
                    if (chatState.currentCardName != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        '🃏 Card: ${chatState.currentCardName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5A6E85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // Quick Prompt Chips Carousel
            Container(
              height: 50,
              color: const Color(0xFFF6F8FC),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = _quickPrompts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ActionChip(
                      elevation: 0,
                      pressElevation: 0,
                      backgroundColor: const Color(0xFFEEF5FA),
                      side: const BorderSide(
                        color: Color(0xFFD4E3ED),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      label: Text(
                        prompt,
                        style: const TextStyle(
                          color: Color(0xFF0F5B7A),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () => _handleSend(prompt),
                    ),
                  );
                },
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];
                  final isUser = message.sender == 'user';
                  final isError = message.isError ||
                      message.text.contains('interrupted') ||
                      message.text.contains('Error');

                  if (isUser) {
                    // User Message Block
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'You',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5A6E85),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.perm_identity_rounded,
                                size: 14,
                                color: Color(0xFF5A6E85),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.78,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF006D85),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF006D85).withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (isError) {
                    // Error Message Block
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: Color(0xFFB91C1C),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Mystic Oracle',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB91C1C),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.85,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE8E8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFCA5A5).withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormattedText(
                                  message.text,
                                  const TextStyle(
                                    color: Color(0xFF991B1B),
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                  boldColor: const Color(0xFF7F1D1D),
                                  italicColor: const Color(0xFF991B1B),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    ref
                                        .read(aiChatProvider.notifier)
                                        .retryLastMessage();
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        size: 16,
                                        color: Color(0xFF991B1B),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Retry Connection',
                                        style: TextStyle(
                                          color: Color(0xFF991B1B),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Regular AI Response Block
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: Color(0xFF0F5B7A),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Mystic Oracle',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F5B7A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.85,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFEBF1F5),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildFormattedText(
                                    message.text,
                                    const TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontSize: 14.5,
                                      height: 1.45,
                                    ),
                                    boldColor: const Color(0xFF1A202C),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: message.text),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Response copied! 🔮'),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Color(0xFF006D85),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 8, top: 2),
                                    child: Icon(
                                      Icons.copy_rounded,
                                      size: 14,
                                      color: Color(0xFFA0AEC0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),

            // Loading Indicator
            if (chatState.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF006D85).withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF006D85),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Consulting the stars...',
                            style: TextStyle(
                              color: Color(0xFF0F5B7A),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Bottom Input Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Analyze Reading Button (if reading context exists)
                  if (chatState.currentReadingTitle != null &&
                      chatState.messages.length <= 1) // Only show if chat is fresh
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006D85),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: chatState.isLoading
                              ? null
                              : () {
                                  ref.read(aiChatProvider.notifier).analyzeCurrentReading();
                                  _scrollToBottom();
                                },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Get AI Insight on This Reading',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(
                            color: Color(0xFF2D3748),
                            fontSize: 14.5,
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _handleSend(),
                          decoration: InputDecoration(
                            hintText: 'Ask Mystic Oracle...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Color(0xFFCBD5E1),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Color(0xFF006D85),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF006D85),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => _handleSend(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
