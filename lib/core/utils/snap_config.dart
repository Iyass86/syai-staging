import 'package:flutter_oauth_chat/core/services/storage_service.dart';
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
  static String pixelsEndpoint() =>
      'https://iyass861.app.n8n.cloud/webhook/pixels';
  // OAuth scopes for Snap Marketing API
  static const List<String> defaultScopes = [
    'snapchat-marketing-api',
    'snapchat-marketing-api-read',
    'snapchat-marketing-api-write'
  ];
  // OAuth redirect URI
  static final accessTokenExamples =
      "eyJpc3MiOiJodHRwczpcL1wvYWNjb3VudHMuc25hcGNoYXQuY29tXC9hY2NvdW50c1wvb2F1dGgyXC90b2tlbiIsInR5cCI6IkpXVCIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJhbGciOiJkaXIiLCJraWQiOiJhY2Nlc3MtdG9rZW4tYTEyOGNiYy1oczI1Ni4wIn0..X0jbiFAvWzQno3RJJTZ0XQ.MUtSZC2QbF6tfkXZxFThVplkB46qDk0B_0Sf0fK-sn2hXgiOU7vf-2y0tVCDJepGH0VUB1Gu5GpgznLHklxoOYSVfxx5NkdxczBicbOtzHVHgxp-D3Y0XbcpvxSeo_AxbcWHxWo1yoXxnWY3cgMSvFNskv0xTpHhEjRfqQ2ty8ofxdlmqu4JgTNf-7eltlUaef-_5iyXWP_5OJvKJ47EU_rJRD7bdLms_6XMt5dyP9x_N-jtTU6lfUccMkXkuefKkYZyQpGBHu7k3Is6ixS9Wc5yb7nR1OqSvc8AGWFq9JqVKbPHacy9TImerLSB4g1cjsIWqVvbijWollzULnpm8zvhS4dRVz8GcMwuZpmMJZGL54dS0aa0-zvhKnjhQdJmjwJNnSeNZhX2Yg8QaFVwf_tMBcOWgK-RS4EBrW3XXJnYsVgdGgs4Om_UwxWcTFFnqi5RkTgX5GqJ8uX5FYanyA2B-no_c9KcVtWOPklCLe-1Do60lCDWTsdcpl5a_T_C7QUuNIexzWhkR-pT1Anb87ItLvvBVP9PwUWcFKwdcd8ct-TzoKjXH0VbNJ7AZ7qJqXJ7sexsAvWGUmv6Ds3G4SsxpFz0nkr3xFinMMShGOWqPRI4yaJWefB3q_7gSNSXT6b8noktyYs9AFDj6yGZZtkRYaO2PAjVgyVzmV320OkmvpDsy5wbI0Y9TRcHyPyHU7sIrJBCbbf_nNtNIXN8o0ZDM-VENCrnHq_IGT78YsQ.6R6Y1mio3lMCFNYQZZtaag";

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
