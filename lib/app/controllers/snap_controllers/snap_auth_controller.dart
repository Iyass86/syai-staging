import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';

import 'package:flutter_oauth_chat/app/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/app/data/models/ads_manager.dart';
import 'package:flutter_oauth_chat/app/data/models/snap_token_response.dart';
import 'package:flutter_oauth_chat/app/repositories/snap_repository.dart';
import 'package:flutter_oauth_chat/app/routes/app_routes.dart';
import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:flutter_oauth_chat/app/utils/constants.dart';

class SnapAuthController extends GetxController {
  static SnapAuthController get to => Get.find();

  static const String _defaultRedirectUri =
      'https://syai-staging.onrender.com/snap_callback.html';
  static const String _defaultClientId = 'a29cb8b0-bec3-4137-95cc-9a51707d764a';
  static const String _defaultClientSecret = '5762ac2e4a3637b968fd';
  static const String _defaultGrantType = 'authorization_code';

  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController clientSecretController = TextEditingController();
  final TextEditingController urlCodeController = TextEditingController();
  final TextEditingController redirectUriController = TextEditingController();

  final RxString grantType = _defaultGrantType.obs;
  final RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StorageService get _storageService => Get.find<StorageService>();
  SnapRepository get _snapRepository => Get.find<SnapRepository>();

  @override
  void onInit() {
    super.onInit();
    if (_storageService.snapTokenResponse?.accessToken.isNotEmpty ?? false) {
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

  void _initializeFormWithDefaults() {
    redirectUriController.text = _defaultRedirectUri;
    clientIdController.text = _defaultClientId;
    clientSecretController.text = _defaultClientSecret;
  }

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

  String? extractAuthorizationCodeFromUrl(String callbackUrl) {
    return extractQueryParameter(callbackUrl, 'code');
  }

  String? extractStateFromUrl(String callbackUrl) {
    return extractQueryParameter(callbackUrl, 'state');
  }

  Map<String, String?> extractErrorFromUrl(String callbackUrl) {
    final uri = Uri.tryParse(callbackUrl);
    if (uri == null) return {};

    return {
      'error': uri.queryParameters['error'],
      'error_description': uri.queryParameters['error_description'],
      'error_uri': uri.queryParameters['error_uri'],
    };
  }

  Future<void> generateAccessToken() async {
    Map<String, dynamic> snapAuth = await getSnapAuth();
    if (snapAuth.isEmpty) {
      _showErrorMessage('Please fill in all required fields');
      return;
    }
    _setLoadingState(true);

    try {
      final tokenResponse = await _requestAccessToken(snapAuth);

      await _storageService.saveSnapToken(tokenResponse.toJson());
      update();
      debugPrint(
          'Access token generated successfully: ${tokenResponse.accessToken}');

      final adsManager = _buildAdsManagerModel(tokenResponse);
      await _storageService.saveAdsManager(adsManager.toJson());

      _showSuccessMessage('Access token generated successfully');
      _navigateToAdAccounts();
    } catch (e) {
      _handleTokenGenerationError(e);
    } finally {
      _setLoadingState(false);
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

  Future<SnapTokenResponse> _requestAccessToken(
      Map<String, dynamic> snapAuth) async {
    return await _snapRepository.generateAccessToken(
      clientId: snapAuth['clientId'] ?? '',
      clientSecret: snapAuth['clientSecret'] ?? '',
      authorizationCode: snapAuth['code'] ?? '',
      redirectUri: snapAuth['redirectUri'] ?? '',
    );
  }

  Future<void> saveSnapAuth() async {
    final mapData = {
      'clientId': clientIdController.text.trim(),
      'clientSecret': clientSecretController.text.trim(),
      'code': urlCodeController.text.trim(),
      'redirectUri': redirectUriController.text.trim(),
    };
    await _storageService.saveSnapAuth(mapData);
  }

  Future<Map<String, dynamic>> getSnapAuth() async {
    return _storageService.getSnapAuth();
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

  Future<void> handleOAuthCallback(String callbackUrl) async {
    try {
      final code = extractAuthorizationCodeFromUrl(callbackUrl);
      final state = extractStateFromUrl(callbackUrl);
      final errorInfo = extractErrorFromUrl(callbackUrl);

      if (errorInfo['error'] != null) {
        final error = errorInfo['error']!;
        final errorDescription =
            errorInfo['error_description'] ?? 'Unknown error';
        _showErrorMessage('OAuth Error: $error - $errorDescription');
        debugPrint('OAuth error: $error - $errorDescription');
        return;
      }

      if (code == null || code.isEmpty) {
        _showErrorMessage('Authorization code not found in callback URL');
        return;
      }

      if (state != null && state.isNotEmpty) {
        final storedState = await _storageService.getCsrfState();
        if (storedState != null && storedState != state) {
          _showErrorMessage('Invalid state parameter - possible CSRF attack');
          debugPrint('State mismatch: expected $storedState, got $state');
          return;
        }
      }

      urlCodeController.text = code;
      debugPrint('Authorization code extracted from callback: $code');
      update();
    } catch (e) {
      _showErrorMessage('Failed to process OAuth callback: $e');
      debugPrint('OAuth callback processing error: $e');
    }
  }

  Future<void> initiateOAuthFlow() async {
    try {
      saveSnapAuth();
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

  Future<void> disconnectSnapAuth() async {
    try {
      _setLoadingState(true);

      await _clearAllSnapData();

      Get.offNamed(AppRoutes.snapAuth);

      debugPrint('Snap authentication disconnected successfully');
    } catch (error) {
      _showErrorMessage('Failed to disconnect Snapchat account');
      debugPrint('Error disconnecting Snap auth: $error');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> _clearAllSnapData() async {
    await _storageService.removeSnapToken();
    await _storageService.removeAdsManager();
    await _storageService.removeSelectedOrganization();
    update();
  }

  bool get isSnapAuthenticated {
    return _storageService.snapTokenResponse?.accessToken.isNotEmpty ?? false;
  }

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
