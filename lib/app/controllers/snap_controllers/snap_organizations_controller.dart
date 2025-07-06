import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/app/data/models/organization.dart';
import 'package:flutter_oauth_chat/app/repositories/snap_repository.dart';
import 'package:flutter_oauth_chat/app/routes/app_routes.dart';
import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:get/get.dart';
import '../message_display_controller.dart';

/// Controller responsible for managing organizations data and operations
/// Handles fetching, filtering, and displaying organizations from Snapchat Ads API
class SnapOrganizationsController extends GetxController {
  // ===============================
  // CONSTANTS
  // ===============================
  static const Duration _snackbarDuration = Duration(seconds: 3);
  static const Duration _successSnackbarDuration = Duration(seconds: 2);

  // ===============================
  // OBSERVABLES & STATE
  // ===============================

  // Controllers
  MessageDisplayController get _messageController =>
      Get.find<MessageDisplayController>();
  final RxBool isLoading = false.obs;
  final Rx<OrganizationsResponse?> organizationsResponse =
      Rx<OrganizationsResponse?>(null);
  final RxString errorMessage = ''.obs;

  // Selected organization reactive state

  // ===============================
  // DEPENDENCY INJECTION
  // ===============================
  SnapRepository get _snapRepository => Get.find<SnapRepository>();

  // ===============================
  // LIFECYCLE METHODS
  // ===============================
  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    // Load previously selected organization

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrganizations();
    });
  }

  /// Load selected organization state from storage
  void _loadSelectedOrganizationState() {
    try {
      final organization = _storageService.selectedOrganization;
    } catch (e) {
      debugPrint('Error loading selected organization state: $e');
    }
  }

  // ===============================
  // DATA FETCHING METHODS
  // ===============================
  /// Fetch all organizations
  Future<void> fetchOrganizations() async {
    try {
      _setLoadingState(true);
      _clearErrorMessage();

      final response = await _requestOrganizations();

      _handleSuccessfulResponse(response);
    } on SnapApiException catch (e) {
      _handleSnapApiError(e);
    } catch (e) {
      _handleGenericError(e);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<OrganizationsResponse> _requestOrganizations() async {
    return await _snapRepository.getOrganizations();
  }

  void _handleSuccessfulResponse(OrganizationsResponse response) {
    organizationsResponse.value = response;
    final organizationCount = response.organizations.length;

    _showSuccessMessage(
      'Found $organizationCount organization${organizationCount == 1 ? '' : 's'}',
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
      debugPrint('Organizations Network Error: $fullMessage');
      return;
    }

    errorMessage.value = fullMessage;
    _showErrorMessage(message, duration: _snackbarDuration);
    debugPrint('Organizations Error: $fullMessage');
  }

  // ===============================
  // DATA ACCESS GETTERS
  // ===============================
  /// Get a list of all organizations
  List<Organization> get organizations {
    return _getFilteredOrganizations(requireSuccess: true);
  }

  /// Get a list of all organization names
  List<String> get organizationNames {
    if (!_hasOrganizationsData) return [];

    return organizationsResponse.value!.organizations
        .map((item) => item.organization.name)
        .toList();
  }

  /// Get total count of organizations
  int get totalOrganizationsCount {
    return organizationsResponse.value?.organizations.length ?? 0;
  }

  /// Get count of successful organizations
  int get successfulOrganizationsCount {
    return organizations.length;
  }

  /// Check if organizations data is available
  bool get _hasOrganizationsData {
    return organizationsResponse.value != null;
  }

  /// Get filtered organizations based on criteria
  List<Organization> _getFilteredOrganizations({
    bool requireSuccess = false,
  }) {
    if (!_hasOrganizationsData) return [];

    return organizationsResponse.value!.organizations
        .where((item) {
          bool passesSuccessCheck = true;

          if (requireSuccess) {
            passesSuccessCheck = item.subRequestStatus == 'success';
          }

          return passesSuccessCheck;
        })
        .map((item) => item.organization)
        .toList();
  }

  // ===============================
  // PUBLIC ACTION METHODS
  // ===============================
  /// Clear the current organizations data
  void clearData() {
    organizationsResponse.value = null;
    _clearErrorMessage();
  }

  /// Refresh organizations data
  Future<void> refreshOrganizations() async {
    await fetchOrganizations();
  }

  /// Retry fetching organizations (alias for refresh)
  Future<void> retryFetch() async {
    await refreshOrganizations();
  }

  StorageService get _storageService => Get.find<StorageService>();

  /// Handle organization tap navigation
  void onTapOrganization(Organization organization) {
    try {
      // Save the selected organization
      _storageService.saveOrganization(organization);

      // Update reactive state

      // Navigate to accounts page
      Get.toNamed(AppRoutes.snapAccounts);

      debugPrint(
          'Organization saved and navigation initiated: ${organization.name} (${organization.id})');
    } catch (e) {
      // Handle save error
      _showErrorMessage('Failed to save organization: $e');
      debugPrint('Error saving organization: $e');
    }
  }

  /// Get currently selected organization from storage
  Organization? getSelectedOrganization() {
    try {
      return _storageService.selectedOrganization;
    } catch (e) {
      debugPrint('Error getting selected organization: $e');
      return null;
    }
  }

  /// Clear selected organization
  Future<void> clearSelectedOrganization() async {
    try {
      await _storageService.removeSelectedOrganization();

      // Clear reactive state

      _showSuccessMessage('Organization selection cleared');
      debugPrint('Selected organization cleared');
    } catch (e) {
      _showErrorMessage('Failed to clear organization selection');
      debugPrint('Error clearing selected organization: $e');
    }
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
    _messageController.displaySuccess(message,
        duration: duration ?? _successSnackbarDuration);
  }

  void _showErrorMessage(String message, {Duration? duration}) {
    _messageController.displayError(message,
        duration: duration ?? _snackbarDuration);
  }

  void _showNetworkErrorMessage() {
    _messageController.displayNetworkError(
      'فشل الاتصال. يرجى التحقق من:\n• الاتصال بالإنترنت\n• إعدادات الجدار الناري\n• إعدادات VPN\n• حاول تحديث الصفحة',
      duration: const Duration(seconds: 6),
    );
  }
}
