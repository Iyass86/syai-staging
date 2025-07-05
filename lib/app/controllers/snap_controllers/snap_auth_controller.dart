import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';

import 'package:flutter_oauth_chat/app/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/app/data/models/ads_manager.dart';
import 'package:flutter_oauth_chat/app/data/models/snap_token_response.dart';
import 'package:flutter_oauth_chat/app/repositories/ads_managers_repository.dart';
import 'package:flutter_oauth_chat/app/repositories/snap_repository.dart';
import 'package:flutter_oauth_chat/app/routes/app_routes.dart';
import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:flutter_oauth_chat/app/utils/constants.dart';

/// Controller responsible for managing the addition and configuration of Ads Managers
/// Handles OAuth flow, token generation, and CRUD operations for Ads Manager entities
class SnapAuthController extends GetxController {
  static SnapAuthController get to => Get.find();
  // ===============================
  // CONSTANTS & DEFAULT VALUES
  // ===============================
  static const String _defaultRedirectUri =
      'https://fce3-213-6-133-123.ngrok-free.app/snap_callback.html';
  static const String _defaultClientId = '03124e03-2fe7-4a74-a5d2-476d94fe1c8f';
  static const String _defaultClientSecret = '7b3364d56eceb31ed325';

  static const String _defaultGrantType = 'authorization_code';

  // ===============================
  // FORM CONTROLLERS & OBSERVABLES
  // ===============================

  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController clientSecretController = TextEditingController();
  final TextEditingController urlCodeController = TextEditingController();
  final TextEditingController redirectUriController = TextEditingController();

  final RxString grantType = _defaultGrantType.obs;
  final RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StorageService get _storageService => Get.find<StorageService>();
  SnapRepository get _snapRepository => Get.find<SnapRepository>();
  AdsManagerRepository get _adsManagerRepository =>
      Get.find<AdsManagerRepository>();

  @override
  void onInit() {
    super.onInit();
    if (_storageService.snapTokenResponse?.accessToken.isNotEmpty ?? false) {
      // Defer navigation until after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(AppRoutes.snapOrganizations);
      });
    } else {
      _initializeFormWithDefaults();
      _storageService.removeAdsManager();
      _loadStoredAdsManager();
    }
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  // ===============================
  // INITIALIZATION METHODS
  // ===============================
  void _initializeFormWithDefaults() {
    redirectUriController.text = _defaultRedirectUri;
    clientIdController.text = _defaultClientId;
    clientSecretController.text = _defaultClientSecret;
  }

  /// Load previously stored AdsManager data into form fields
  void _loadStoredAdsManager() {
    final storedAdsManager = _storageService.getAdsManager();
    if (storedAdsManager != null) {
      clientIdController.text = storedAdsManager.clientId;
      clientSecretController.text = storedAdsManager.clientSecret;
      redirectUriController.text = storedAdsManager.redirectUri;
      urlCodeController.text = storedAdsManager.code;
      debugPrint('Loaded stored AdsManager data into form fields');
    }
  }

  void _disposeControllers() {
    clientIdController.dispose();
    clientSecretController.dispose();
    urlCodeController.dispose();
    redirectUriController.dispose();
  }

  // ===============================
  // VALIDATION METHODS
  // ===============================
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  bool _validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // ===============================
  // UTILITY METHODS
  // ===============================
  String? extractQueryParameter(String? url, String paramName) {
    if (url == null || url.isEmpty) return null;

    try {
      final uri = Uri.parse(url);
      return uri.queryParameters[paramName];
    } on FormatException catch (e) {
      debugPrint('Invalid URL format: $url - Error: $e');
      return null;
    }
  }

  /// Extract authorization code from callback URL
  /// This method can be used by the callback page to extract the code
  String? extractAuthorizationCodeFromUrl(String callbackUrl) {
    return extractQueryParameter(callbackUrl, 'code');
  }

  /// Extract state parameter from callback URL for CSRF validation
  String? extractStateFromUrl(String callbackUrl) {
    return extractQueryParameter(callbackUrl, 'state');
  }

  /// Extract error information from callback URL
  Map<String, String?> extractErrorFromUrl(String callbackUrl) {
    final uri = Uri.tryParse(callbackUrl);
    if (uri == null) return {};

    return {
      'error': uri.queryParameters['error'],
      'error_description': uri.queryParameters['error_description'],
      'error_uri': uri.queryParameters['error_uri'],
    };
  }

  // ===============================
  // ADS MANAGER CRUD METHODS
  // ===============================
  /// Processes the ads manager by either creating new or updating existing one
  Future<void> _processAdsManager(SnapTokenResponse snapTokenResponse) async {
    if (!_validateForm()) {
      return;
    }

    _setLoadingState(true);

    try {
      final adsManager = _buildAdsManagerModel(snapTokenResponse);
      final existingManager = await _findExistingManager();

      if (existingManager != null) {
        await _updateExistingManager(existingManager, adsManager);
      } else {
        await _createNewManager(adsManager);
      }
    } catch (error) {
      _handleAdsManagerError(error);
    }
  }

  AdsManagerModel _buildAdsManagerModel(SnapTokenResponse snapTokenResponse) {
    return AdsManagerModel(
      id: 0,
      clientId: clientIdController.text.trim(),
      clientSecret: clientSecretController.text.trim(),
      code: urlCodeController.text.trim(),
      redirectUri: redirectUriController.text.trim(),
      createdAt: DateTime.now().toUtc(),
      grantType: _defaultGrantType,
      uid: _storageService.getUser()?.id ?? '',
      accessToken: snapTokenResponse.accessToken,
      refreshToken: snapTokenResponse.refreshToken,
      expiresIn: snapTokenResponse.expiresIn,
    );
  }

  Future<AdsManagerModel?> _findExistingManager() async {
    return await _adsManagerRepository.getById(
      id: _storageService.getUser()?.id ?? '',
      key: 'UID',
    );
  }

  Future<void> _updateExistingManager(
    AdsManagerModel existingManager,
    AdsManagerModel newManager,
  ) async {
    final updatedManager = newManager.copyWith(id: existingManager.id);
    await _adsManagerRepository.update(
      updatedManager.id.toString(),
      updatedManager.toJson(),
    );

    // Save updated ads manager to storage service
    await _storageService.saveAdsManager(updatedManager.toJson());

    _showSuccessMessage('Ads Manager updated successfully');
    _navigateToAdAccounts();
  }

  Future<void> _createNewManager(AdsManagerModel adsManager) async {
    await _adsManagerRepository.create(adsManager.toJson());

    // Save created ads manager to storage service
    await _storageService.saveAdsManager(adsManager.toJson());

    _showSuccessMessage('Ads Manager created successfully');
    _navigateToAdAccounts();
  }

  void _handleAdsManagerError(dynamic error) {
    String errorMessage = 'Error processing ads manager';

    // Handle different types of errors
    if (error.toString().contains('DioException') ||
        error.toString().contains('connection error') ||
        error.toString().contains('XMLHttpRequest onError')) {
      _showNetworkErrorMessage();
      _setLoadingState(false);
      debugPrint('Ads manager network error: $error');
      return;
    } else if (error.toString().contains('CORS') ||
        error.toString().contains('Cross-Origin')) {
      errorMessage =
          'Network access blocked. Please ensure the application is properly configured for web access.';
    } else if (error.toString().contains('duplicate') ||
        error.toString().contains('already exists')) {
      errorMessage = 'Ads Manager already exists for this organization';
    } else if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      errorMessage =
          'Network error. Please check your connection and try again.';
    } else if (error.toString().contains('permission') ||
        error.toString().contains('unauthorized')) {
      errorMessage = 'Permission denied. Please check your credentials';
    } else if (error.toString().contains('timeout')) {
      errorMessage = 'Request timed out. Please try again.';
    } else if (error.toString().contains('certificate') ||
        error.toString().contains('SSL') ||
        error.toString().contains('TLS')) {
      errorMessage =
          'Security certificate error. Please check your network settings.';
    }

    _showErrorMessage(errorMessage);
    _setLoadingState(false);
    debugPrint('Ads manager error: $error');
  }

  // ===============================
  // LEGACY METHOD (KEPT FOR COMPATIBILITY)
  // ===============================
  @Deprecated('Use _processAdsManager instead')
  void addManger(SnapTokenResponse snapTokenResponse) {
    _processAdsManager(snapTokenResponse);
  }

  // ===============================
  // TOKEN MANAGEMENT METHODS
  // ===============================  /// Generates access token using the authorization code
  Future<void> generateAccessToken() async {
    if (!_validateForm()) {
      _showErrorMessage('Please fill in all required fields');
      return;
    }

    _setLoadingState(true);

    try {
      final tokenResponse = await _requestAccessToken();

      await _storageService.saveSnapToken(tokenResponse.toJson());
      update();

      // Build and save AdsManager to storage service before database operations
      final adsManager = _buildAdsManagerModel(tokenResponse);
      await _storageService.saveAdsManager(adsManager.toJson());

      await _processAdsManager(tokenResponse);
    } catch (e) {
      _handleTokenGenerationError(e);
    } finally {
      _setLoadingState(false);
    }
  }

  /// Retry token generation with exponential backoff
  Future<void> retryGenerateAccessToken({int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await generateAccessToken();
        return; // Success, exit retry loop
      } catch (e) {
        if (attempt == maxRetries) {
          _showErrorMessage(
              'Failed after $maxRetries attempts. Please check your network connection.');
          return;
        }

        // Exponential backoff: wait 2^attempt seconds
        final waitTime = Duration(seconds: 2 * attempt);
        _showErrorMessage(
            'Attempt $attempt failed. Retrying in ${waitTime.inSeconds} seconds...');

        await Future.delayed(waitTime);
      }
    }
  }

  Future<SnapTokenResponse> _requestAccessToken() async {
    return await _snapRepository.generateAccessToken(
      clientId: clientIdController.text.trim(),
      clientSecret: clientSecretController.text.trim(),
      authorizationCode: urlCodeController.text.trim(),
      redirectUri: redirectUriController.text.trim(),
    );
  }

  void _handleTokenGenerationError(dynamic error) {
    String errorMessage = 'An unexpected error occurred';

    if (error is SnapApiException) {
      errorMessage = error.message;
      _showErrorMessage(errorMessage);
    } else if (error.toString().contains('DioException') ||
        error.toString().contains('connection error') ||
        error.toString().contains('XMLHttpRequest onError')) {
      _showNetworkErrorMessage();
      debugPrint('Token generation network error: $error');
      return;
    } else if (error.toString().contains('CORS') ||
        error.toString().contains('Cross-Origin')) {
      errorMessage =
          'Network access blocked. Please ensure the application is properly configured for web access.';
      _showErrorMessage(errorMessage);
    } else if (error.toString().contains('timeout')) {
      errorMessage = 'Request timed out. Please try again.';
      _showErrorMessage(errorMessage);
    } else if (error.toString().contains('certificate') ||
        error.toString().contains('SSL') ||
        error.toString().contains('TLS')) {
      errorMessage =
          'Security certificate error. Please check your network settings.';
      _showErrorMessage(errorMessage);
    } else if (error.toString().contains('401') ||
        error.toString().contains('Unauthorized')) {
      errorMessage =
          'Invalid credentials. Please check your client ID and secret.';
      _showErrorMessage(errorMessage);
    } else if (error.toString().contains('403') ||
        error.toString().contains('Forbidden')) {
      errorMessage = 'Access forbidden. Please check your permissions.';
      _showErrorMessage(errorMessage);
    } else if (error.toString().contains('404')) {
      errorMessage = 'API endpoint not found. Please contact support.';
      _showErrorMessage(errorMessage);
    } else if (error.toString().contains('500')) {
      errorMessage = 'Server error. Please try again later.';
      _showErrorMessage(errorMessage);
    } else {
      _showErrorMessage(errorMessage);
    }

    debugPrint('Token generation error: $error');
  }

  // ===============================
  // BACKWARD COMPATIBILITY GETTER
  // ===============================
  @Deprecated('Use _snapRepository instead')
  SnapRepository get snapRepository => _snapRepository;
  // ===============================
  // OAUTH FLOW METHODS
  // ===============================
  /// Handle OAuth callback from the callback page
  Future<void> handleOAuthCallback(String callbackUrl) async {
    try {
      // Extract parameters from callback URL
      final code = extractAuthorizationCodeFromUrl(callbackUrl);
      final state = extractStateFromUrl(callbackUrl);
      final errorInfo = extractErrorFromUrl(callbackUrl);

      // Check for OAuth errors
      if (errorInfo['error'] != null) {
        final error = errorInfo['error']!;
        final errorDescription =
            errorInfo['error_description'] ?? 'Unknown error';
        _showErrorMessage('OAuth Error: $error - $errorDescription');
        debugPrint('OAuth error: $error - $errorDescription');
        return;
      }

      // Validate authorization code
      if (code == null || code.isEmpty) {
        _showErrorMessage('Authorization code not found in callback URL');
        return;
      }

      // Validate state parameter if present (CSRF protection)
      if (state != null && state.isNotEmpty) {
        final storedState = await _storageService.getCsrfState();
        if (storedState != null && storedState != state) {
          _showErrorMessage('Invalid state parameter - possible CSRF attack');
          debugPrint('State mismatch: expected $storedState, got $state');
          return;
        }
      }

      // Fill the authorization code in the form
      urlCodeController.text = code;
      debugPrint('Authorization code extracted from callback: $code');
      update();
      // Automatically generate access token
      await generateAccessToken();
    } catch (e) {
      _showErrorMessage('Failed to process OAuth callback: $e');
      debugPrint('OAuth callback processing error: $e');
    }
  }

  /// Initiates the OAuth authorization flow for Snapchat Ads API
  Future<void> initiateOAuthFlow() async {
    try {
      final state = AppConstants.generateState();
      await _storageService.saveCsrfState(state);

      final authUrl = _buildAuthorizationUrl(state);
      final result = await _authenticateWithWebAuth(authUrl);
      final code = _extractAuthorizationCode(result);

      if (code != null) {
        urlCodeController.text = code;
        debugPrint('Authorization code received: $code');
        _showSuccessMessage('Authorization code received successfully');
      } else {
        _showErrorMessage('Failed to extract authorization code');
      }
    } catch (e) {
      String errorMessage = 'Failed to initiate OAuth flow';

      if (e.toString().contains('user_cancelled') ||
          e.toString().contains('cancelled')) {
        errorMessage = 'OAuth flow was cancelled by user';
      } else if (e.toString().contains('DioException') ||
          e.toString().contains('connection error')) {
        errorMessage =
            'Network connection failed during OAuth. Please check your internet connection.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'OAuth request timed out. Please try again.';
      } else {
        errorMessage = 'Failed to initiate OAuth flow: $e';
      }

      _showErrorMessage(errorMessage);
      debugPrint('OAuth flow error: $e');
    }
  }

  Uri _buildAuthorizationUrl(String state) {
    return Uri.parse(AppConstants.oauthAuthorizationEndpoint).replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': clientIdController.text.trim(),
        'redirect_uri': redirectUriController.text.trim(),
        'scope': AppConstants.oauthScopes.join(' '),
        'state': state,
      },
    );
  }

  Future<String> _authenticateWithWebAuth(Uri authUrl) async {
    return await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: "https",
      options: const FlutterWebAuth2Options(
        useWebview: true,
        // Add timeout to prevent hanging (in milliseconds)
        timeout: 300000, // 5 minutes
      ),
    );
  }

  String? _extractAuthorizationCode(String result) {
    return Uri.parse(result).queryParameters['code'];
  }

  // ===============================
  // STORAGE UTILITY METHODS
  // ===============================
  /// Check if AdsManager is already stored locally
  bool hasStoredAdsManager() {
    return _storageService.getAdsManager() != null;
  }

  /// Get the currently stored AdsManager from storage service
  AdsManagerModel? getStoredAdsManager() {
    return _storageService.getAdsManager();
  }

  /// Remove AdsManager from storage service
  Future<void> removeStoredAdsManager() async {
    await _storageService.removeAdsManager();
  }

  // ===============================
  // LOGOUT/DISCONNECT METHODS
  // ===============================
  /// Disconnect Snap authentication and clear all stored data
  Future<void> disconnectSnapAuth() async {
    try {
      _setLoadingState(true);

      // Clear all Snap-related data from storage
      await _clearAllSnapData();

      // Navigate back to auth page
      Get.offNamed(AppRoutes.snapAuth);

      debugPrint('Snap authentication disconnected successfully');
    } catch (error) {
      _showErrorMessage('Failed to disconnect Snapchat account');
      debugPrint('Error disconnecting Snap auth: $error');
    } finally {
      _setLoadingState(false);
    }
  }

  /// Clear all Snap-related data from storage
  Future<void> _clearAllSnapData() async {
    await _storageService.removeSnapToken();
    await _storageService.removeAdsManager();
    await _storageService.removeSelectedOrganization();
    update(); // Update reactive state
  }

  /// Check if user is currently authenticated with Snap
  bool get isSnapAuthenticated {
    return _storageService.snapTokenResponse?.accessToken.isNotEmpty ?? false;
  }

  // ===============================
  // UI HELPER METHODS
  // ===============================
  void _setLoadingState(bool loading) {
    isLoading.value = loading;
  }

  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: const Duration(seconds: 4),
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

  void _navigateToAdAccounts() {
    Get.offAllNamed(AppRoutes.snapOrganizations);
  }
}
