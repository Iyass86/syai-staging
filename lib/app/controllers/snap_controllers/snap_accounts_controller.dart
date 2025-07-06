import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/data/models/ad_account.dart';
import 'package:flutter_oauth_chat/app/repositories/snap_repository.dart';
import 'package:flutter_oauth_chat/app/routes/app_routes.dart';
import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:get/get.dart';

import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_valid_token_controller.dart';
import 'package:flutter_oauth_chat/app/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/app/data/models/ad_accounts_response.dart';
import 'package:flutter_oauth_chat/app/data/models/ads_manager.dart';
import 'package:flutter_oauth_chat/app/utils/constants.dart';

/// Controller responsible for managing ad accounts data and operations
/// Handles fetching, filtering, and displaying ad accounts from Snapchat Ads API
class SnapAccountsController extends GetxController {
  // ===============================
  // CONSTANTS
  // ===============================
  static const Duration _snackbarDuration = Duration(seconds: 3);
  static const Duration _successSnackbarDuration = Duration(seconds: 2);

  // ===============================
  // OBSERVABLES & STATE
  // ===============================
  final RxBool isLoading = false.obs;
  final Rx<AdAccountsResponse?> adAccountsResponse =
      Rx<AdAccountsResponse?>(null);
  final RxString errorMessage = ''.obs;
  late String organizationId;
  // ===============================
  // DEPENDENCY INJECTION
  // ===============================
  SnapValidTokenController get _snapController =>
      Get.find<SnapValidTokenController>();

  StorageService get _storageService => Get.find<StorageService>();
  // ===============================
  // LIFECYCLE METHODS
  // ===============================

  @override
  void onInit() {
    super.onInit();
    organizationId = _storageService.selectedOrganization?.id ??
        _storageService.snapTokenResponse?.organizationId ??
        '';
    _initializeController();
  }

  void _initializeController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAdAccounts();
    });
  }

  // ===============================
  // DATA FETCHING METHODS
  // ===============================
  /// Fetch all ad accounts for the organization
  Future<void> fetchAdAccounts() async {
    try {
      _setLoadingState(true);
      _clearErrorMessage();

      final response = await _requestAdAccounts();

      _handleSuccessfulResponse(response);
    } on SnapApiException catch (e) {
      _handleSnapApiError(e);
    } catch (e) {
      _handleGenericError(e);
    } finally {
      _setLoadingState(false);
    }
  }

  Future<AdAccountsResponse> _requestAdAccounts() async {
    return getAllAdAccounts();
  }

  SnapRepository get _snapRepository => Get.find<SnapRepository>();
  Future<AdAccountsResponse> getAllAdAccounts() async {
    final response = await _snapRepository.getAllAdAccounts();

    return response;
  }

  void _handleSuccessfulResponse(AdAccountsResponse response) {
    adAccountsResponse.value = response;
    final accountCount = response.adAccounts.length;

    _showSuccessMessage(
      'Found $accountCount ad account${accountCount == 1 ? '' : 's'}',
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
      debugPrint('Ad Accounts Network Error: $fullMessage');
      return;
    }

    errorMessage.value = fullMessage;
    _showErrorMessage(message, duration: _snackbarDuration);
    debugPrint('Ad Accounts Error: $fullMessage');
  }

  // ===============================
  // DATA ACCESS GETTERS
  // ===============================
  /// Get a list of active ad accounts
  List<dynamic> get activeAdAccounts {
    return _getFilteredAdAccounts(
      statusFilter: 'ACTIVE',
      requireSuccess: true,
    );
  }

  /// Get a list of all ad account names
  List<String> get adAccountNames {
    if (!_hasAdAccountsData) return [];

    return adAccountsResponse.value!.adAccounts
        .map((item) => item.adAccount.name)
        .toList();
  }

  /// Get total count of ad accounts
  int get totalAdAccountsCount {
    return adAccountsResponse.value?.adAccounts.length ?? 0;
  }

  /// Get count of active ad accounts
  int get activeAdAccountsCount {
    return activeAdAccounts.length;
  }

  /// Check if ad accounts data is available
  bool get _hasAdAccountsData {
    return adAccountsResponse.value != null;
  }

  /// Get filtered ad accounts based on criteria
  List<dynamic> _getFilteredAdAccounts({
    String? statusFilter,
    bool requireSuccess = false,
  }) {
    if (!_hasAdAccountsData) return [];

    return adAccountsResponse.value!.adAccounts
        .where((item) {
          bool passesStatusCheck = true;
          bool passesSuccessCheck = true;

          if (requireSuccess) {
            passesSuccessCheck = item.subRequestStatus == 'success';
          }

          if (statusFilter != null) {
            passesStatusCheck = item.adAccount.status == statusFilter;
          }

          return passesStatusCheck && passesSuccessCheck;
        })
        .map((item) => item.adAccount)
        .toList();
  }

  // ===============================
  // PUBLIC ACTION METHODS
  // ===============================
  /// Clear the current ad accounts data
  void clearData() {
    adAccountsResponse.value = null;
    _clearErrorMessage();
  }

  /// Refresh ad accounts data
  Future<void> refreshAdAccounts() async {
    await fetchAdAccounts();
  }

  /// Retry fetching ad accounts (alias for refresh)
  Future<void> retryFetch() async {
    await refreshAdAccounts();
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
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      duration: duration ?? _successSnackbarDuration,
      margin: const EdgeInsets.all(8),
    );
  }

  void _showErrorMessage(String message, {Duration? duration}) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      duration: duration ?? _snackbarDuration,
      margin: const EdgeInsets.all(8),
    );
  }

  void _showNetworkErrorMessage() {
    Get.snackbar(
      'Network Error',
      'Connection failed. Please check:\n• Internet connection\n• Firewall settings\n• VPN configuration\n• Try refreshing the page',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.1),
      colorText: Colors.orange,
      duration: const Duration(seconds: 6),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connection failed. Please check:',
            style: TextStyle(
                color: Colors.orange[700], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('• Internet connection',
              style: TextStyle(color: Colors.orange[700])),
          Text('• Firewall settings',
              style: TextStyle(color: Colors.orange[700])),
          Text('• VPN configuration',
              style: TextStyle(color: Colors.orange[700])),
          Text('• Try refreshing the page',
              style: TextStyle(color: Colors.orange[700])),
        ],
      ),
    );
  }

  selectAdAccount(AdAccount account) {
    _storageService.saveSelectedAdAccount(account);
    Get.toNamed(AppRoutes.chat);
  }
}
