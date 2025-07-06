import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_oauth_chat/core/exceptions/snap_api_exception.dart';
import 'package:flutter_oauth_chat/core/models/ad_accounts_response.dart';
import 'package:flutter_oauth_chat/core/models/organization.dart';
import 'package:flutter_oauth_chat/core/models/pixel.dart';
import 'package:flutter_oauth_chat/core/models/snap_token_response.dart';
import 'package:flutter_oauth_chat/core/services/storage_service.dart';
import 'package:flutter_oauth_chat/core/utils/snap_config.dart';
import 'package:get/get.dart';

class SnapRepository {
  final Dio dio;

  SnapRepository({
    required this.dio,
  });

  final StorageService _storageService = Get.find<StorageService>();
  Future<void> ensureValidToken() async {
    // if (_storageService.snapTokenResponse?.accessToken.isEmpty ?? true) {
    //   throw SnapApiException('No token available. Please authenticate first.');
    // }
    // final clientId = _storageService.getAdsManager()?.clientId ?? '';
    // final clientSecret = _storageService.getAdsManager()?.clientSecret ?? '';
    // // Check if the token is expired
    // if (isTokenExpired()) {
    //   final refreshedToken = await refreshAccessToken(
    //     clientId: clientId,
    //     clientSecret: clientSecret,
    //     refreshToken: _storageService.snapTokenResponse!.refreshToken,
    //   );

    //   // Update the storage service with the new token
    //   await _saveTokenResponse(refreshedToken);
    // }
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
      var body = {
        'client_id': _storageService.getAdsManager()?.clientId ?? '',
        'client_secret': _storageService.getAdsManager()?.clientSecret ?? '',
        'access_token': _storageService.snapTokenResponse?.accessToken ?? '',
        'refresh_token': _storageService.snapTokenResponse?.refreshToken ?? '',
      };
      debugPrint("##### Requesting organizations with body: $body");
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

  /// Get all pixels for an ad account
  Future<PixelsResponse> getPixels(String adAccountId) async {
    try {
      await ensureValidToken();

      final response = await dio.post(
        SnapApiConfig.pixelsEndpoint(),
        data: {
          'ad_account_id': _storageService.selectedAdAccount?.id,
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

      // Handle the case where API returns array with single response object
      final responseData = response.data;
      Map<String, dynamic> formattedResponse;

      if (responseData is List && responseData.isNotEmpty) {
        // API returns array with single object: [{request_status: SUCCESS, request_id: ..., pixels: []}]
        formattedResponse = responseData[0] as Map<String, dynamic>;
      } else if (responseData is Map<String, dynamic>) {
        // If API returns properly formatted object, use as-is
        formattedResponse = responseData;
      } else {
        throw SnapApiException(
          'Unexpected response format for pixels API',
          statusCode: response.statusCode,
          errorData: responseData,
        );
      }

      debugPrint(
          "### Pixels response: ${formattedResponse['pixels']?.length ?? 0} pixels found");
      return PixelsResponse.fromJson(formattedResponse);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorDescription = errorData['error_description'] ??
            errorData['error'] ??
            'Unknown error';
        throw SnapApiException(
          'Fetch pixels failed: $errorDescription',
          statusCode: e.response?.statusCode,
          errorData: errorData,
        );
      }
      rethrow;
    }
  }
}
