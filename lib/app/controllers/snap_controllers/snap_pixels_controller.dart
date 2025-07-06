import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/app/data/models/pixel.dart';
import 'package:flutter_oauth_chat/app/repositories/snap_repository.dart';
import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:get/get.dart';
import '../message_display_controller.dart';

/// Controller responsible for managing pixels data and operations
/// Handles fetching, filtering, and displaying pixels from Snapchat Ads API
class SnapPixelsController extends GetxController {
  // ===============================
  // CONSTANTS
  // ===============================
  static const Duration _snackbarDuration = Duration(seconds: 3);
  static const Duration _successSnackbarDuration = Duration(seconds: 2);

  // ===============================
  // OBSERVABLES & STATE
  // ===============================
  final RxBool isLoading = false.obs;
  final Rx<PixelsResponse?> pixelsResponse = Rx<PixelsResponse?>(null);
  final RxString errorMessage = ''.obs;

  // ===============================
  // DEPENDENCY INJECTION
  // ===============================
  MessageDisplayController get _messageController =>
      Get.find<MessageDisplayController>();
  SnapRepository get _snapRepository => Get.find<SnapRepository>();
  StorageService get _storageService => Get.find<StorageService>();
  String get adAccountId => _storageService.selectedAdAccount?.id ?? '';
  String get adAccountName => _storageService.selectedAdAccount?.name ?? '';

  // ===============================
  // LIFECYCLE METHODS
  // ===============================

  @override
  void onInit() {
    super.onInit();
    // Get ad account info from arguments

    _initializeController();
  }

  void _initializeController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPixels();
    });
  }

  // ===============================
  // DATA FETCHING METHODS
  // ===============================
  /// Fetch all pixels for the ad account
  Future<void> fetchPixels() async {
    try {
      _setLoadingState(true);
      _clearErrorMessage();

      final response = await _requestPixels();
      _handleSuccessfulResponse(response);
    } on SnapApiException catch (e) {
      _handleSnapApiError(e);
    } catch (e) {
      _handleGenericError(e);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<PixelsResponse> _requestPixels() async {
    return await _snapRepository.getPixels(adAccountId);
  }

  void _handleSuccessfulResponse(PixelsResponse response) {
    pixelsResponse.value = response;
    final pixelCount = response.pixels.length;

    _showSuccessMessage(
      'Found $pixelCount pixel${pixelCount == 1 ? '' : 's'}',
      duration: _successSnackbarDuration,
    );
  }

  void _handleSnapApiError(SnapApiException error) {
    final message = error.message;
    errorMessage.value = message;
    _showErrorMessage(message, duration: _snackbarDuration);
  }

  void _handleGenericError(dynamic error) {
    const message = 'An unexpected error occurred';
    final fullMessage = '$message: ${error.toString()}';

    // Handle network-specific errors
    if (error.toString().contains('DioException') ||
        error.toString().contains('connection error') ||
        error.toString().contains('XMLHttpRequest onError')) {
      _showNetworkErrorMessage();
      errorMessage.value = 'Network connection failed';
      debugPrint('Pixels Network Error: $fullMessage');
      return;
    }

    errorMessage.value = fullMessage;
    _showErrorMessage(message, duration: _snackbarDuration);
    debugPrint('Pixels Error: $fullMessage');
  }

  // ===============================
  // DATA ACCESS GETTERS
  // ===============================
  /// Get a list of active pixels
  List<Pixel> get activePixels {
    return _getFilteredPixels(
      statusFilter: 'ACTIVE',
      requireSuccess: true,
    );
  }

  /// Get a list of all pixel names
  List<String> get pixelNames {
    if (!_hasPixelsData) return [];

    return pixelsResponse.value!.pixels.map((item) => item.pixel.name).toList();
  }

  /// Get total count of pixels
  int get totalPixelsCount {
    return pixelsResponse.value?.pixels.length ?? 0;
  }

  /// Get count of active pixels
  int get activePixelsCount {
    return activePixels.length;
  }

  /// Check if pixels data is available
  bool get _hasPixelsData {
    return pixelsResponse.value != null;
  }

  /// Get filtered pixels based on criteria
  List<Pixel> _getFilteredPixels({
    String? statusFilter,
    bool requireSuccess = false,
  }) {
    if (!_hasPixelsData) return [];

    return pixelsResponse.value!.pixels
        .where((item) {
          bool passesStatusCheck = true;
          bool passesSuccessCheck = true;

          if (requireSuccess) {
            passesSuccessCheck = item.subRequestStatus == 'SUCCESS';
          }

          if (statusFilter != null) {
            passesStatusCheck = item.pixel.status == statusFilter;
          }

          return passesStatusCheck && passesSuccessCheck;
        })
        .map((item) => item.pixel)
        .toList();
  }

  // ===============================
  // PUBLIC ACTION METHODS
  // ===============================
  /// Clear the current pixels data
  void clearData() {
    pixelsResponse.value = null;
    _clearErrorMessage();
  }

  /// Refresh pixels data
  Future<void> refreshPixels() async {
    await fetchPixels();
  }

  /// Retry fetching pixels (alias for refresh)
  Future<void> retryFetch() async {
    await refreshPixels();
  }

  /// Copy pixel JavaScript code to clipboard
  void copyPixelCode(Pixel pixel) {
    _messageController.displaySuccess(
      'تم نسخ كود البكسل "${pixel.name}" إلى الحافظة',
      duration: _successSnackbarDuration,
    );
  }

  /// Navigate to pixel setup page
  void navigateToPixelSetup(String pixelId) {
    Get.toNamed('/snap-pixel-setup?clientId=$pixelId');
  }

  // ===============================
  // PRIVATE HELPER METHODS
  // ===============================
  void _setLoadingState(bool loading) {
    isLoading.value = loading;
  }

  void _clearErrorMessage() {
    errorMessage.value = '';
  }

  void _showSuccessMessage(String message, {Duration? duration}) {
    _messageController.displaySuccess(
      message,
      duration: duration ?? _successSnackbarDuration,
    );
  }

  void _showErrorMessage(String message, {Duration? duration}) {
    _messageController.displayError(
      message,
      duration: duration ?? _snackbarDuration,
    );
  }

  void _showNetworkErrorMessage() {
    _messageController.displayNetworkError(
      'فشل الاتصال. يرجى التحقق من الإنترنت وإعدادات الشبكة ثم إعادة المحاولة.',
      duration: const Duration(seconds: 6),
    );
  }
}
