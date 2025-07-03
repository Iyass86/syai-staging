import 'package:flutter/material.dart';
import 'package:positioned_scroll_observer/positioned_scroll_observer.dart';

import '../../controllers/chat_controller.dart';
import '../../data/models/chat_message.dart';
import 'chat_message_widget.dart';

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
    return ObserverProxy(
      observer: controller.observer,
      child: Padding(
        key: ValueKey<int>(index),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ChatMessageWidget(
          message: message,
          isLoading: isLastMessage && isWaitingForResponse,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: 48,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final messageIndex = index;
        final message = messages[messageIndex] as ChatMessage;
        final isLastMessage = messageIndex == messages.length;

        return _buildMessageItem(message, isLastMessage, index);
      },
    );
  }
}
