import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/chat_message.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isLoading;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.isLoading = false,
  });

  bool get isFromCurrentUser => message.message?.isFromCurrentUser ?? true;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isFromCurrentUser) ...[
          _buildAvatar(context),
          const SizedBox(width: 8),
        ],
        Flexible(
          flex: !isFromCurrentUser ? 1 : 0,
          child: Wrap(
            children: [
              _buildMessageBubble(context),
            ],
          ),
        ),
        if (isFromCurrentUser) ...[
          const SizedBox(width: 8),
          _buildAvatar(context),
        ],
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: isFromCurrentUser
            ? theme.colorScheme.primary.withOpacity(0.9)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isFromCurrentUser ? 20 : 8),
          bottomRight: Radius.circular(isFromCurrentUser ? 8 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color:
                theme.shadowColor.withOpacity(isFromCurrentUser ? 0.12 : 0.08),
            blurRadius: 8,
            offset: Offset(0, isFromCurrentUser ? 2 : 1),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromCurrentUser) ...[
            Row(
              children: [
                Text(
                  "SyAi",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          _buildMessageContent(context, theme),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isFromCurrentUser && message.message?.type == 'assistant')
                Icon(
                  Icons.smart_toy_outlined,
                  size: 12,
                  color: (isFromCurrentUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface)
                      .withOpacity(0.7),
                ),
              if (!isFromCurrentUser && message.message?.type == 'assistant')
                const SizedBox(width: 4),
              Text(
                _formatTimestamp(DateTime.now()),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: (isFromCurrentUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface)
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, ThemeData theme) {
    final messageType = message.message?.type;
    final content = message.message?.content ?? '';

    if (messageType == 'user_image') {
      return _buildImageMessage(context, theme, content);
    } else {
      return _buildTextMessage(context, theme, content);
    }
  }

  Widget _buildTextMessage(
      BuildContext context, ThemeData theme, String content) {
    return SelectableText(
      content,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: isFromCurrentUser
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        height: 1.4,
      ),
    );
  }

  Widget _buildImageMessage(
      BuildContext context, ThemeData theme, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showFullScreenImage(context, imageUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 250,
                maxHeight: 300,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.onErrorContainer,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'failed_to_load_image'.tr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'image_shared'.tr,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isFromCurrentUser
                ? theme.colorScheme.onPrimary.withOpacity(0.8)
                : theme.colorScheme.onSurface.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: imageUrl,
                      child: InteractiveViewer(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final double size = 36;

    return Hero(
      tag: isFromCurrentUser ? 'user-avatar' : 'ai-avatar',
      child: Material(
        elevation: 4,
        shadowColor: theme.shadowColor.withOpacity(0.2),
        shape: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isFromCurrentUser
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
              width: 2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isFromCurrentUser
                  ? [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ]
                  : [
                      theme.colorScheme.secondary,
                      theme.colorScheme.secondaryContainer,
                    ],
            ),
          ),
          child: Center(
            child: isFromCurrentUser
                ? Icon(
                    Icons.person,
                    size: 20,
                    color: theme.colorScheme.onPrimary,
                  )
                : Text(
                    'AI',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    final time = timestamp ?? DateTime.now();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
