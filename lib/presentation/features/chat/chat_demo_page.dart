import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/chat_animations.dart';
import 'widgets/typewriter_text.dart';

class ChatDemoPage extends StatefulWidget {
  const ChatDemoPage({Key? key}) : super(key: key);

  @override
  State<ChatDemoPage> createState() => _ChatDemoPageState();
}

class _ChatDemoPageState extends State<ChatDemoPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final RxBool _isTyping = false.obs;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    // Scroll to bottom
    _scrollToBottom();

    // Simulate AI thinking and response
    _isTyping.value = true;

    Future.delayed(const Duration(milliseconds: 1500), () {
      _isTyping.value = false;
      setState(() {
        _messages.add({
          'text': _getAIResponse(userMessage),
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getAIResponse(String userMessage) {
    // Simple demo responses
    final responses = [
      'هذا مثال رائع على تأثير الكتابة حرف بحرف! 😊 يمكنك أن تشاهد كيف يظهر النص بطريقة سلسة ومتطورة.',
      'أستطيع أن أساعدك في مهامك المختلفة بطريقة سلسة ومتطورة. التصميم الجديد يحاكي أفضل منصات الذكاء الاصطناعي.',
      'التحسينات الجديدة تجعل التجربة أكثر سلاسة وجمالاً. المؤشرات المتحركة والحركات السلسة تضيف لمسة احترافية.',
      'هل تريد رؤية المزيد من الميزات الرائعة؟ يمكنك تجربة إرسال رسائل مختلفة لمشاهدة التأثيرات المتنوعة.',
      'تم تصميم هذه الواجهة لتكون مثل أفضل منصات الذكاء الاصطناعي مثل ChatGPT و Gemini. كل حرف يظهر بطريقة منفصلة وسلسة.',
    ];

    return responses[DateTime.now().millisecond % responses.length];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1200;
          final isTablet =
              constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
          final isMobile = constraints.maxWidth <= 768;

          // Simple layout: centered input when empty, normal layout when messages exist
          if (_messages.isEmpty) {
            return _buildEmptyStateLayout(
                colorScheme, isDesktop, isTablet, isMobile);
          } else {
            return Column(
              children: [
                Expanded(child: _buildMessagesList(colorScheme)),
                _buildMessageInputCard(
                    colorScheme, isDesktop, isTablet, isMobile),
              ],
            );
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SyAi Chat Demo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'مثال تطبيقي على التصميم المتطور',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateLayout(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Column(
      children: [
        // Main content area
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop
                    ? 48
                    : isTablet
                        ? 32
                        : 24,
                vertical: 40,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop
                      ? 800
                      : isTablet
                          ? 600
                          : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo with animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * value),
                          child: Opacity(
                            opacity: value,
                            child: Container(
                              width: isDesktop
                                  ? 80
                                  : isTablet
                                      ? 70
                                      : 60,
                              height: isDesktop
                                  ? 80
                                  : isTablet
                                      ? 70
                                      : 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.primary.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.psychology_alt_rounded,
                                size: isDesktop
                                    ? 40
                                    : isTablet
                                        ? 35
                                        : 30,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                        height: isDesktop
                            ? 32
                            : isTablet
                                ? 28
                                : 24),

                    // Welcome title with animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1200),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: Text(
                              'مرحباً بك في SyAi Demo',
                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 32
                                    : isTablet
                                        ? 28
                                        : 24,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(
                        height: isDesktop
                            ? 16
                            : isTablet
                                ? 14
                                : 12),

                    // Subtitle with animation
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1400),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: Text(
                              'جرب تأثيرات الكتابة المتطورة والتصميم الأنيق',
                              style: TextStyle(
                                fontSize: isDesktop
                                    ? 18
                                    : isTablet
                                        ? 16
                                        : 14,
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Simple input area at bottom
        _buildSimpleInput(colorScheme, isDesktop, isTablet, isMobile),
      ],
    );
  }

  Widget _buildSimpleInput(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        isDesktop
            ? 48
            : isTablet
                ? 32
                : 24,
        16,
        isDesktop
            ? 48
            : isTablet
                ? 32
                : 24,
        isDesktop
            ? 32
            : isTablet
                ? 28
                : 24,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(
          maxWidth: isDesktop
              ? 800
              : isTablet
                  ? 600
                  : double.infinity,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Typing indicator for empty state
            Obx(() {
              if (_isTyping.value) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(
                    top: isDesktop
                        ? 20
                        : isTablet
                            ? 18
                            : 16,
                    bottom: isDesktop
                        ? 16
                        : isTablet
                            ? 14
                            : 12,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop
                        ? 20
                        : isTablet
                            ? 18
                            : 16,
                    vertical: isDesktop
                        ? 12
                        : isTablet
                            ? 10
                            : 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildThinkingDots(colorScheme, isDesktop, isTablet),
                      SizedBox(
                          width: isDesktop
                              ? 12
                              : isTablet
                                  ? 10
                                  : 8),
                      Text(
                        'SyAi يفكر...',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.8),
                          fontSize: isDesktop
                              ? 16
                              : isTablet
                                  ? 15
                                  : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Input area
            Container(
              padding: EdgeInsets.all(isDesktop
                  ? 8
                  : isTablet
                      ? 6
                      : 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text input
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: isDesktop
                            ? 120
                            : isTablet
                                ? 100
                                : 80,
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك هنا...',
                          hintStyle: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5),
                            fontSize: isDesktop
                                ? 16
                                : isTablet
                                    ? 15
                                    : 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isDesktop
                                ? 16
                                : isTablet
                                    ? 14
                                    : 12,
                            vertical: isDesktop
                                ? 16
                                : isTablet
                                    ? 14
                                    : 12,
                          ),
                        ),
                        maxLines: null,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: isDesktop
                              ? 16
                              : isTablet
                                  ? 15
                                  : 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  // Send button
                  Obx(() => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: IconButton(
                          onPressed: _isTyping.value ? null : _sendMessage,
                          style: IconButton.styleFrom(
                            backgroundColor: _isTyping.value
                                ? colorScheme.surfaceContainerHighest
                                : colorScheme.primary,
                            foregroundColor: _isTyping.value
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.all(isDesktop
                                ? 16
                                : isTablet
                                    ? 14
                                    : 12),
                          ),
                          icon: _isTyping.value
                              ? SizedBox(
                                  width: isDesktop
                                      ? 20
                                      : isTablet
                                          ? 18
                                          : 16,
                                  height: isDesktop
                                      ? 20
                                      : isTablet
                                          ? 18
                                          : 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Icon(
                                  Icons.send_rounded,
                                  size: isDesktop
                                      ? 20
                                      : isTablet
                                          ? 18
                                          : 16,
                                ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThinkingDots(
      ColorScheme colorScheme, bool isDesktop, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: isDesktop
                    ? 8
                    : isTablet
                        ? 7
                        : 6,
                height: isDesktop
                    ? 8
                    : isTablet
                        ? 7
                        : 6,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(
                    0.3 + (0.7 * (0.5 + 0.5 * value)),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildMessagesList(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surface,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isUser = message['isUser'] as bool;

          // Check if this is the last AI message
          bool isLastAiMessage = false;
          if (!isUser) {
            // Find the last AI message index
            int lastAiIndex = -1;
            for (int i = _messages.length - 1; i >= 0; i--) {
              if (!_messages[i]['isUser']) {
                lastAiIndex = i;
                break;
              }
            }
            isLastAiMessage = index == lastAiIndex;
          }

          return AnimatedMessageBubble(
            isUser: isUser,
            delay: Duration(milliseconds: 100 * index),
            child: Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                decoration: BoxDecoration(
                  color: isUser
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isUser
                    ? Text(
                        message['text'],
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      )
                    : isLastAiMessage
                        ? TypewriterAnimatedText(
                            text: message['text'],
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                            ),
                            speed: const Duration(milliseconds: 50),
                            showCursor: true,
                            cursorColor: colorScheme.primary,
                          )
                        : Text(
                            message['text'],
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                            ),
                          ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInputCard(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Card(
      margin: EdgeInsets.all(isDesktop
          ? 24
          : isTablet
              ? 20
              : 16),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isDesktop
              ? 20
              : isTablet
                  ? 18
                  : 16),
          child: Column(
            children: [
              // Typing indicator
              Obx(() {
                if (_isTyping.value) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: isDesktop ? 16 : 12),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 16 : 12,
                      vertical: isDesktop ? 10 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildThinkingDots(colorScheme, isDesktop, isTablet),
                        SizedBox(width: isDesktop ? 10 : 8),
                        Text(
                          'SyAi يكتب...',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.8),
                            fontSize: isDesktop
                                ? 16
                                : isTablet
                                    ? 15
                                    : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Input row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: isDesktop
                              ? 16
                              : isTablet
                                  ? 15
                                  : 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isDesktop
                              ? 20
                              : isTablet
                                  ? 18
                                  : 16,
                          vertical: isDesktop
                              ? 16
                              : isTablet
                                  ? 14
                                  : 12,
                        ),
                        isDense: true,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: isDesktop
                            ? 16
                            : isTablet
                                ? 15
                                : 14,
                      ),
                    ),
                  ),
                  SizedBox(
                      width: isDesktop
                          ? 16
                          : isTablet
                              ? 14
                              : 12),
                  Obx(() => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: FloatingActionButton(
                          onPressed: _isTyping.value ? null : _sendMessage,
                          elevation: _isTyping.value ? 1 : 3,
                          mini: !isDesktop,
                          backgroundColor: _isTyping.value
                              ? colorScheme.surfaceContainerHighest
                              : colorScheme.primary,
                          child: _isTyping.value
                              ? SizedBox(
                                  width: isDesktop ? 24 : 20,
                                  height: isDesktop ? 24 : 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Icon(
                                  Icons.send,
                                  color: colorScheme.onPrimary,
                                  size: isDesktop ? 24 : 20,
                                ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
