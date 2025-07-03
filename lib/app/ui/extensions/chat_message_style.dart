import 'package:flutter/material.dart';
import '../../data/models/chat_message.dart';

extension ChatMessageStyle on ChatMessage {
  BoxDecoration getMessageDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isUser = message?.type == 'user_local';

    return BoxDecoration(
      color: isUser ? colorScheme.primary : colorScheme.surfaceVariant,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
        bottomLeft: Radius.circular(isUser ? 20 : 4),
        bottomRight: Radius.circular(isUser ? 4 : 20),
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  TextStyle getMessageTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isUser = message?.type == 'user_local';

    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: isUser ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          height: 1.4,
        );
  }
}
