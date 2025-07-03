import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_oauth_chat/app/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/app/data/models/ad_accounts_response.dart';
import 'package:flutter_oauth_chat/app/data/models/organization.dart';
import 'package:flutter_oauth_chat/app/data/models/snap_token_response.dart';
import 'package:flutter_oauth_chat/app/services/storage_service.dart';
import 'package:flutter_oauth_chat/app/utils/snap_config.dart';
import 'package:get/get.dart';

class SnapRepository {
  final Dio dio;

  SnapRepository({
    required this.dio,
  });

  final StorageService _storageService = Get.find<StorageService>();
  Future<void> ensureValidToken() async {
    if (_storageService.snapTokenResponse?.accessToken.isEmpty ?? true) {
      throw SnapApiException('No token available. Please authenticate first.');
    }
    final clientId = _storageService.getAdsManager()?.clientId ?? '';
    final clientSecret = _storageService.getAdsManager()?.clientSecret ?? '';

    if (isTokenExpired()) {
      final refreshedToken = await refreshAccessToken(
        clientId: clientId,
        clientSecret: clientSecret,
        refreshToken: _storageService.snapTokenResponse!.refreshToken,
      );

      // Update the storage service with the new token
      await _saveTokenResponse(refreshedToken);
    }
  }

  bool isTokenExpired() {
    if (_storageService.snapTokenResponse == null) return true;

    // Add buffer time of 5 minutes (300 seconds)
    final expirationTime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 300;
    return _storageService.snapTokenResponse!.expiresIn <= expirationTime;
  }

  /// Save token response to storage
  Future<void> _saveTokenResponse(SnapTokenResponse tokenResponse) async {
    await _storageService.saveSnapToken(tokenResponse.toJson());
  }

  Future<SnapTokenResponse> generateAccessToken(
      {required String clientId,
      required String clientSecret,
      required String redirectUri,
      required String authorizationCode}) async {
    try {
      final data = {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': authorizationCode,
        'redirect_uri': redirectUri,
      };
      debugPrint("$data");
      final response = await dio.post(
        SnapApiConfig.tokenEndpoint,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final tokenResponse = SnapTokenResponse.fromJson(response.data);
        return tokenResponse;
      } else {
        throw SnapApiException(
          'Failed to generate access token',
          statusCode: response.statusCode,
          errorData: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorDescription = errorData['error_description'] ??
            errorData['error'] ??
            'Unknown error';
        throw SnapApiException(
          'Token generation failed: $errorDescription',
          statusCode: e.response?.statusCode,
          errorData: errorData,
        );
      }
      rethrow;
    }
  }

  Future<SnapTokenResponse> refreshAccessToken(
      {required String clientId,
      required String clientSecret,
      required String refreshToken}) async {
    try {
      final data = {
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      };

      final response = await dio.post(
        SnapApiConfig.tokenEndpoint,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final tokenResponse = SnapTokenResponse.fromJson(response.data);
        return tokenResponse;
      } else {
        throw SnapApiException(
          'Failed to refresh access token',
          statusCode: response.statusCode,
          errorData: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorDescription = errorData['error_description'] ??
            errorData['error'] ??
            'Unknown error';
        throw SnapApiException(
          'Token refresh failed: $errorDescription',
          statusCode: e.response?.statusCode,
          errorData: errorData,
        );
      }
      rethrow;
    }
  }

  final accessTokenExampls =
      "eyJpc3MiOiJodHRwczpcL1wvYWNjb3VudHMuc25hcGNoYXQuY29tXC9hY2NvdW50c1wvb2F1dGgyXC90b2tlbiIsInR5cCI6IkpXVCIsImVuYyI6IkExMjhDQkMtSFMyNTYiLCJhbGciOiJkaXIiLCJraWQiOiJhY2Nlc3MtdG9rZW4tYTEyOGNiYy1oczI1Ni4wIn0..X0jbiFAvWzQno3RJJTZ0XQ.MUtSZC2QbF6tfkXZxFThVplkB46qDk0B_0Sf0fK-sn2hXgiOU7vf-2y0tVCDJepGH0VUB1Gu5GpgznLHklxoOYSVfxx5NkdxczBicbOtzHVHgxp-D3Y0XbcpvxSeo_AxbcWHxWo1yoXxnWY3cgMSvFNskv0xTpHhEjRfqQ2ty8ofxdlmqu4JgTNf-7eltlUaef-_5iyXWP_5OJvKJ47EU_rJRD7bdLms_6XMt5dyP9x_N-jtTU6lfUccMkXkuefKkYZyQpGBHu7k3Is6ixS9Wc5yb7nR1OqSvc8AGWFq9JqVKbPHacy9TImerLSB4g1cjsIWqVvbijWollzULnpm8zvhS4dRVz8GcMwuZpmMJZGL54dS0aa0-zvhKnjhQdJmjwJNnSeNZhX2Yg8QaFVwf_tMBcOWgK-RS4EBrW3XXJnYsVgdGgs4Om_UwxWcTFFnqi5RkTgX5GqJ8uX5FYanyA2B-no_c9KcVtWOPklCLe-1Do60lCDWTsdcpl5a_T_C7QUuNIexzWhkR-pT1Anb87ItLvvBVP9PwUWcFKwdcd8ct-TzoKjXH0VbNJ7AZ7qJqXJ7sexsAvWGUmv6Ds3G4SsxpFz0nkr3xFinMMShGOWqPRI4yaJWefB3q_7gSNSXT6b8noktyYs9AFDj6yGZZtkRYaO2PAjVgyVzmV320OkmvpDsy5wbI0Y9TRcHyPyHU7sIrJBCbbf_nNtNIXN8o0ZDM-VENCrnHq_IGT78YsQ.6R6Y1mio3lMCFNYQZZtaag";

  /// Get all ad accounts for an organization
  Future<AdAccountsResponse> getAllAdAccounts() async {
    try {
      await ensureValidToken();
      final response = await dio.post(
        SnapApiConfig.adAccountsEndpoint(),
        data: {
          'organization_id': _storageService.selectedOrganization?.id ??
              _storageService.snapTokenResponse?.organizationId ??
              '',
          'client_id': _storageService.getAdsManager()?.clientId ?? '',
          'client_secret': _storageService.getAdsManager()?.clientSecret ?? '',
          'access_token': _storageService.snapTokenResponse?.accessToken ?? '',
          'refresh_token':
              _storageService.snapTokenResponse?.refreshToken ?? '',
        },
        options: Options(
          headers: SnapApiConfig.snapHeader,
        ),
      );
      return AdAccountsResponse.fromJson({"adaccounts": response.data});
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorDescription = errorData['error_description'] ??
            errorData['error'] ??
            'Unknown error';
        throw SnapApiException(
          'Fetch ad accounts failed: $errorDescription',
          statusCode: e.response?.statusCode,
          errorData: errorData,
        );
      }
      rethrow;
    }
  }

  Future<OrganizationsResponse> getOrganizations() async {
    try {
      await ensureValidToken();
      final response = await dio.post(
        SnapApiConfig.organizationsEndpoint(),
        data: {
          'client_id': _storageService.getAdsManager()?.clientId ?? '',
          'client_secret': _storageService.getAdsManager()?.clientSecret ?? '',
          'access_token': _storageService.snapTokenResponse?.accessToken ?? '',
          'refresh_token':
              _storageService.snapTokenResponse?.refreshToken ?? '',
        },
        options: Options(
          headers: SnapApiConfig.snapHeader,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return OrganizationsResponse.fromJson({"organizations": response.data});
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired access token');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Forbidden: Insufficient permissions');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later');
      } else {
        throw Exception('Failed to fetch organizations: ${e.message}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
