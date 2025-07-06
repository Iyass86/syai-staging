import 'package:get/get.dart';

enum MessageType { error, success, warning, networkError }

class MessageDisplayController extends GetxController {
  // Observable variables for different message types
  final RxString _errorMessage = ''.obs;
  final RxString _successMessage = ''.obs;
  final RxString _warningMessage = ''.obs;
  final RxString _networkErrorMessage = ''.obs;

  final RxBool _showError = false.obs;
  final RxBool _showSuccess = false.obs;
  final RxBool _showWarning = false.obs;
  final RxBool _showNetworkError = false.obs;

  // Getters
  String get errorMessage => _errorMessage.value;
  String get successMessage => _successMessage.value;
  String get warningMessage => _warningMessage.value;
  String get networkErrorMessage => _networkErrorMessage.value;

  bool get showError => _showError.value;
  bool get showSuccess => _showSuccess.value;
  bool get showWarning => _showWarning.value;
  bool get showNetworkError => _showNetworkError.value;

  // Show error message
  void displayError(String message, {Duration? duration}) {
    _errorMessage.value = message;
    _showError.value = true;

    // Hide other messages
    hideSuccess();
    hideWarning();
    hideNetworkError();

    // Auto hide after duration
    if (duration != null) {
      Future.delayed(duration, () {
        hideError();
      });
    }
  }

  // Show success message
  void displaySuccess(String message, {Duration? duration}) {
    _successMessage.value = message;
    _showSuccess.value = true;

    // Hide other messages
    hideError();
    hideWarning();
    hideNetworkError();

    // Auto hide after duration
    if (duration != null) {
      Future.delayed(duration, () {
        hideSuccess();
      });
    }
  }

  // Show warning message
  void displayWarning(String message, {Duration? duration}) {
    _warningMessage.value = message;
    _showWarning.value = true;

    // Hide other messages
    hideError();
    hideSuccess();
    hideNetworkError();

    // Auto hide after duration
    if (duration != null) {
      Future.delayed(duration, () {
        hideWarning();
      });
    }
  }

  // Show info message (uses warning style)
  void displayInfo(String message, {Duration? duration}) {
    displayWarning(message, duration: duration);
  }

  // Show network error message
  void displayNetworkError(String message, {Duration? duration}) {
    _networkErrorMessage.value = message;
    _showNetworkError.value = true;

    // Hide other messages
    hideError();
    hideSuccess();
    hideWarning();

    // Auto hide after duration
    if (duration != null) {
      Future.delayed(duration, () {
        hideNetworkError();
      });
    }
  }

  // Hide methods
  void hideError() {
    _showError.value = false;
    _errorMessage.value = '';
  }

  void hideSuccess() {
    _showSuccess.value = false;
    _successMessage.value = '';
  }

  void hideWarning() {
    _showWarning.value = false;
    _warningMessage.value = '';
  }

  void hideNetworkError() {
    _showNetworkError.value = false;
    _networkErrorMessage.value = '';
  }

  // Hide all messages
  void hideAll() {
    hideError();
    hideSuccess();
    hideWarning();
    hideNetworkError();
  }

  // Utility method to show message based on type
  void showMessage(String message, MessageType type, {Duration? duration}) {
    switch (type) {
      case MessageType.error:
        displayError(message, duration: duration);
        break;
      case MessageType.success:
        displaySuccess(message, duration: duration);
        break;
      case MessageType.warning:
        displayWarning(message, duration: duration);
        break;
      case MessageType.networkError:
        displayNetworkError(message, duration: duration);
        break;
    }
  }
}
