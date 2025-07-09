import 'package:flutter/material.dart';
import 'package:positioned_scroll_observer/positioned_scroll_observer.dart';

import '../../../../core/controllers/chat_controller.dart';
import '../../../../core/models/chat_message.dart';
import 'chat_message_widget.dart';
import '../../../shared_widgets/enhanced_list_view.dart';

class ChatMessageList extends StatelessWidget {
  final ChatController controller;
  final ScrollController scrollController;
  final List<dynamic> messages;
  final bool isWaitingForResponse;

  const ChatMessageList({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.messages,
    required this.isWaitingForResponse,
  });

  Widget _buildMessageItem(ChatMessage message, bool isLastMessage, int index) {
    // تحديد ما إذا كانت هذه آخر رسالة من AI
    bool isLastAiMessage = !isWaitingForResponse &&
        (messages.lastOrNull as ChatMessage).id == message.id &&
        message.lastMessageFromAi;
    return ObserverProxy(
      observer: controller.observer,
      child: Padding(
        key: ValueKey<int>(index),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ChatMessageWidget(
          message: message,
          isLoading: isLastMessage && isWaitingForResponse,
          isLastAiMessage: isLastAiMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedListView<ChatMessage>(
      items: messages.cast<ChatMessage>(),
      scrollController: scrollController,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: 48,
      ),
      emptyTitle: "Start a Conversation",
      emptyMessage:
          "Ask me anything about your marketing campaigns and performance",
      emptyIcon: Icons.chat_bubble_outline,
      emptyActionText: "Get Started",
      onEmptyAction: () {
        // Could trigger showing sample questions or focus input
      },
      itemBuilder: (context, message, index) {
        final isLastMessage = index == messages.length - 1;
        return _buildMessageItem(message, isLastMessage, index);
      },
    );
  }
}
