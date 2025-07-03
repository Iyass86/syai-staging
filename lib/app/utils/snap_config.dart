import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:get/get.dart';

class SnapApiConfig {
  static const String baseUrl = 'https://accounts.snapchat.com';
  static const String apiBaseUrl = 'https://adsapi.snapchat.com';
  static const String tokenEndpoint = '$baseUrl/login/oauth2/access_token';
  static const String authEndpoint = '/login/oauth2/authorize';

  // Ad Accounts endpoint
  static String adAccountsEndpoint() =>
      'https://iyass861.app.n8n.cloud/webhook/ad-accounts';
  static String organizationsEndpoint() =>
      'https://iyass861.app.n8n.cloud/webhook/me/organizations';

  // OAuth scopes for Snap Marketing API
  static const List<String> defaultScopes = [
    'snapchat-marketing-api',
    'snapchat-marketing-api-read',
    'snapchat-marketing-api-write'
  ];
  // OAuth redirect URI

  static StorageService get _storageService => Get.find<StorageService>();
  static String? get accessToken =>
      _storageService.snapTokenResponse?.accessToken;
  static Map<String, String> get snapHeader {
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }
}
