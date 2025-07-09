import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/chat_controller.dart';
import '../../shared_widgets/theme_toggle_button.dart';
import 'widgets/message_display_container.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: MessageDisplayContainer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1200;
            final isTablet =
                constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
            final isMobile = constraints.maxWidth <= 768;

            return Obx(() {
              // Simple layout: centered input when empty, normal layout when messages exist
              if (controller.messages.isEmpty) {
                return _buildEmptyStateLayout(
                    colorScheme, isDesktop, isTablet, isMobile);
              } else {
                return Column(
                  children: [
                    _buildLoadingStatus(colorScheme),
                    Expanded(child: _buildMessagesList(colorScheme)),
                    _buildMessageInputCard(
                        colorScheme, isDesktop, isTablet, isMobile),
                  ],
                );
              }
            });
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () => Get.back(),
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(8),
        ),
      ),
      title: Text(
        'SyAi',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      centerTitle: false,
      actions: [
        // Simple menu
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
          onSelected: (value) {
            switch (value) {
              case 'upload':
                controller.pickAndUploadImage();
                break;
              case 'refresh':
                controller.refreshMessages();
                break;
              case 'logout':
                _showLogoutDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'upload',
              child: Row(
                children: [
                  Icon(Icons.attach_file_rounded,
                      color: colorScheme.onSurface, size: 20),
                  SizedBox(width: 12),
                  Text('Upload Image'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: colorScheme.onSurface, size: 20),
                  SizedBox(width: 12),
                  Text('Refresh'),
                ],
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: colorScheme.error, size: 20),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: colorScheme.error)),
                ],
              ),
            ),
          ],
        ),
        const ThemeToggleButton(),
        const SizedBox(width: 8),
      ],
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
                    // Welcome header
                    Text(
                      'Welcome to Chat AI',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 28
                            : isTablet
                                ? 24
                                : 22,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Start chatting with our AI assistant. Ask anything, and it will provide helpful responses.',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 16
                            : isTablet
                                ? 15
                                : 14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32),

                    // AI Assistant initial message
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // AI Avatar
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.psychology_alt_rounded,
                              size: 18,
                              color: colorScheme.onPrimary,
                            ),
                          ),

                          SizedBox(width: 12),

                          // Message content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Assistant',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceVariant
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Hello! How can I assist you today?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.onSurface,
                                      height: 1.4,
                                    ),
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
              ),
            ),
          ),
        ),

        // Input area at bottom
        _buildModernInput(colorScheme, isDesktop, isTablet, isMobile),
      ],
    );
  }

  Widget _buildModernInput(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return Container(
      margin: EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 800 : double.infinity,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text input with integrated buttons
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 20,
                  right: 120, // Space for buttons inside
                  top: 16,
                  bottom: 16,
                ),
                // Integrated buttons as suffix
                suffixIcon: Container(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Attachment button
                      IconButton(
                        onPressed: () => controller.pickAndUploadImage(),
                        icon: Icon(
                          Icons.attach_file_rounded,
                          color: colorScheme.onSurface.withOpacity(0.6),
                          size: 22,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                      ),

                      SizedBox(width: 4),

                      // Send button
                      Obx(() => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: controller.hasText.value &&
                                      !controller.isWaitingForResponse.value
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.primary.withOpacity(0.8),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        colorScheme.outline.withOpacity(0.3),
                                        colorScheme.outline.withOpacity(0.2),
                                      ],
                                    ),
                              boxShadow: controller.hasText.value &&
                                      !controller.isWaitingForResponse.value
                                  ? [
                                      BoxShadow(
                                        color: colorScheme.primary
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: controller.hasText.value &&
                                      !controller.isWaitingForResponse.value
                                  ? controller.sendMessage
                                  : null,
                              icon: controller.isWaitingForResponse.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      Icons.send_rounded,
                                      color: controller.hasText.value &&
                                              !controller
                                                  .isWaitingForResponse.value
                                          ? Colors.white
                                          : colorScheme.onSurface
                                              .withOpacity(0.4),
                                      size: 20,
                                    ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              maxLines: 5,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => controller.sendMessage(),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.4,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStatus(ColorScheme colorScheme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer.withOpacity(0.1),
                    colorScheme.primaryContainer.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading messages...',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildMessagesList(ColorScheme colorScheme) {
    return Obx(() => Container(
          color: colorScheme.surface,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.messages.length,
            // Performance optimizations
            cacheExtent: 500,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final message = controller.messages[index];
              final isUser = message.message?.isFromCurrentUser ?? true;
              final messageText = message.message?.content ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) ...[
                      // AI Avatar
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.psychology_alt_rounded,
                          size: 18,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(width: 12),
                    ],

                    // Message content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // Label
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 4,
                              left: isUser ? 0 : 0,
                              right: isUser ? 0 : 0,
                            ),
                            child: Text(
                              isUser ? 'User' : 'AI Assistant',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),

                          // Message bubble
                          Container(
                            padding: EdgeInsets.all(16),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? colorScheme.primary
                                  : colorScheme.surfaceVariant.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: message.message?.type == 'ai_thinking'
                                ? _buildThinkingText(colorScheme)
                                : Text(
                                    messageText,
                                    style: TextStyle(
                                      color: isUser
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface,
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),

                    if (isUser) ...[
                      SizedBox(width: 12),
                      // User Avatar
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ));
  }

  Widget _buildMessageInputCard(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return _buildModernInput(colorScheme, isDesktop, isTablet, isMobile);
  }

  Widget _buildThinkingText(ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Thinking...',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
            height: 1.4,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 8),
        // Simple dots
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    final colorScheme = Theme.of(Get.context!).colorScheme;

    Get.dialog(
      AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface.withOpacity(0.7),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
