import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/message_display_controller.dart';
import 'error_display_widget.dart';

class MessageDisplayContainer extends StatelessWidget {
  final Widget child;

  const MessageDisplayContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final messageController = Get.find<MessageDisplayController>();

    return Column(
      children: [
        // Error message display
        Obx(() => ErrorDisplayWidget(
              errorMessage: messageController.errorMessage,
              isVisible: messageController.showError,
              onDismiss: () => messageController.hideError(),
            )),

        // Success message display
        Obx(() => SuccessDisplayWidget(
              message: messageController.successMessage,
              isVisible: messageController.showSuccess,
              onDismiss: () => messageController.hideSuccess(),
            )),

        // Network error message display
        Obx(() => NetworkErrorDisplayWidget(
              errorMessage: messageController.networkErrorMessage,
              isVisible: messageController.showNetworkError,
              onDismiss: () => messageController.hideNetworkError(),
              onRetry: () {
                messageController.hideNetworkError();
                // Add retry logic here if needed
              },
            )),

        // Main content
        Expanded(child: child),
      ],
    );
  }
}

class TopMessageDisplay extends StatelessWidget {
  const TopMessageDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final messageController = Get.find<MessageDisplayController>();

    return Column(
      children: [
        // Error message display
        Obx(() => ErrorDisplayWidget(
              errorMessage: messageController.errorMessage,
              isVisible: messageController.showError,
              onDismiss: () => messageController.hideError(),
            )),

        // Success message display
        Obx(() => SuccessDisplayWidget(
              message: messageController.successMessage,
              isVisible: messageController.showSuccess,
              onDismiss: () => messageController.hideSuccess(),
            )),

        // Network error message display
        Obx(() => NetworkErrorDisplayWidget(
              errorMessage: messageController.networkErrorMessage,
              isVisible: messageController.showNetworkError,
              onDismiss: () => messageController.hideNetworkError(),
              onRetry: () {
                messageController.hideNetworkError();
                // Add retry logic here if needed
              },
            )),
      ],
    );
  }
}
