import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/chat_controller.dart';
import 'widgets/chat_message_list.dart';
import '../../shared_widgets/theme_toggle_button.dart';
import 'widgets/message_display_container.dart';
import 'widgets/typewriter_text.dart';
import '../../../core/utils/chat_animations.dart';

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
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SyAi Chat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Obx(() {
              final user = controller.authController.currentUser.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: user != null ? Colors.green : colorScheme.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user?.userMetadata?['name'] ?? 'مستخدم غير معروف',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: colorScheme.onSurface),
          onPressed: controller.refreshMessages,
          tooltip: 'تحديث الرسائل',
        ),
        const ThemeToggleButton(),
        IconButton(
          icon: Icon(Icons.logout, color: colorScheme.error),
          onPressed: () => _showLogoutDialog(),
          tooltip: 'تسجيل الخروج',
        ),
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
                    // App logo with smooth animation
                    SmoothMessageContainer(
                      duration: const Duration(milliseconds: 800),
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

                    SizedBox(
                        height: isDesktop
                            ? 32
                            : isTablet
                                ? 28
                                : 24),

                    // Welcome title with smooth animation
                    SmoothMessageContainer(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        'مرحباً بك في SyAi',
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

                    SizedBox(
                        height: isDesktop
                            ? 16
                            : isTablet
                                ? 14
                                : 12),

                    // Subtitle with smooth animation
                    SmoothMessageContainer(
                      duration: const Duration(milliseconds: 1200),
                      child: Text(
                        'مساعدك الذكي جاهز لمساعدتك',
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
    return SmoothMessageContainer(
      duration: const Duration(milliseconds: 600),
      child: Container(
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
              // Enhanced typing indicator for empty state
              Obx(() {
                if (controller.isWaitingForResponse.value) {
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
                        // Enhanced animated dots
                        EnhancedThinkingIndicator(
                          color: colorScheme.primary,
                          text: '',
                          size: isDesktop
                              ? 8
                              : isTablet
                                  ? 7
                                  : 6,
                        ),
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
                    // Attach button with smooth animation
                    Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: IconButton(
                            icon: controller.isUploadingImage.value
                                ? SizedBox(
                                    width: isDesktop
                                        ? 22
                                        : isTablet
                                            ? 20
                                            : 18,
                                    height: isDesktop
                                        ? 22
                                        : isTablet
                                            ? 20
                                            : 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.attach_file_rounded,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                    size: isDesktop
                                        ? 24
                                        : isTablet
                                            ? 22
                                            : 20,
                                  ),
                            onPressed: controller.isUploadingImage.value
                                ? null
                                : controller.pickAndUploadImage,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(isDesktop
                                  ? 12
                                  : isTablet
                                      ? 10
                                      : 8),
                            ),
                          ),
                        )),

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
                          controller: controller.messageController,
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
                          onSubmitted: (_) => controller.sendMessage(),
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

                    // Send button with smooth animation
                    Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: IconButton(
                            onPressed: controller.isWaitingForResponse.value
                                ? null
                                : controller.sendMessage,
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  controller.isWaitingForResponse.value
                                      ? colorScheme.surfaceContainerHighest
                                      : colorScheme.primary,
                              foregroundColor:
                                  controller.isWaitingForResponse.value
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
                            icon: controller.isWaitingForResponse.value
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
      ),
    );
  }

  Widget _buildLoadingStatus(ColorScheme colorScheme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return SmoothMessageContainer(
          child: Container(
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
                      'جاري تحميل الرسائل...',
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
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildMessagesList(ColorScheme colorScheme) {
    return Obx(() {
      return Container(
        color: colorScheme.surface,
        child: ChatMessageList(
          controller: controller,
          scrollController: controller.scrollController,
          messages: controller.messages,
          isWaitingForResponse: controller.isWaitingForResponse.value,
        ),
      );
    });
  }

  Widget _buildMessageInputCard(
      ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isMobile) {
    return SmoothMessageContainer(
      child: Card(
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
                // Enhanced typing indicator
                Obx(() {
                  if (controller.isWaitingForResponse.value) {
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
                          EnhancedThinkingIndicator(
                            color: colorScheme.primary,
                            text: '',
                            size: isDesktop
                                ? 8
                                : isTablet
                                    ? 7
                                    : 6,
                          ),
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
                    Obx(() => IconButton(
                          icon: controller.isUploadingImage.value
                              ? SizedBox(
                                  width: isDesktop ? 22 : 20,
                                  height: isDesktop ? 22 : 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.primary,
                                  ),
                                )
                              : Icon(
                                  Icons.attach_file,
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                  size: isDesktop
                                      ? 24
                                      : isTablet
                                          ? 22
                                          : 20,
                                ),
                          onPressed: controller.isUploadingImage.value
                              ? null
                              : controller.pickAndUploadImage,
                          style: IconButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerHighest
                                .withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
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
                        onSubmitted: (_) => controller.sendMessage(),
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
                            onPressed: controller.isWaitingForResponse.value
                                ? null
                                : controller.sendMessage,
                            elevation:
                                controller.isWaitingForResponse.value ? 1 : 3,
                            mini: !isDesktop,
                            backgroundColor:
                                controller.isWaitingForResponse.value
                                    ? colorScheme.surfaceContainerHighest
                                    : colorScheme.primary,
                            child: controller.isWaitingForResponse.value
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
      ),
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
          'تسجيل الخروج',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
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
            child: const Text('إلغاء'),
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
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
