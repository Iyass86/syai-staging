import 'package:dio/dio.dart';
import '../utils/constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));
  }

  Future<Map<String, dynamic>> exchangeCodeForToken(String code) async {
    try {
      final response = await _dio.post('/oauth/token', data: {
        'grant_type': 'authorization_code',
        'client_id': AppConstants.oauthClientId,
        'code': code,
        'redirect_uri': AppConstants.oauthRedirectUri
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to exchange code for token: $e');
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('/api/user');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }
}
