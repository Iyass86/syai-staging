import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_organizations_controller.dart';
import 'package:get/get.dart';

import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_accounts_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_auth_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/auth_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/login_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/register_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_valid_token_controller.dart';
import 'package:flutter_oauth_chat/app/repositories/ads_managers_repository.dart';
import 'package:flutter_oauth_chat/app/repositories/snap_repository.dart';
import 'package:flutter_oauth_chat/app/repositories/user_repository.dart';
import 'package:flutter_oauth_chat/app/services/supabase_service.dart';

import '../controllers/theme_controller.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Dio dio = Dio();
    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => debugPrint('[DIO] $object'),
      ),
      InterceptorsWrapper(
        onError: (error, handler) {
          _handleDioError(error);
          handler.next(error);
        },
      ),
    ]);
    Get.put<Dio>(dio, permanent: true);

    // Core services
    Get.lazyPut<SupabaseAuthService>(() => SupabaseAuthService(), fenix: true);
    Get.lazyPut<SupabaseStorageService>(
        () => SupabaseStorageService('default_bucket'),
        fenix: true);
    Get.lazyPut<UserRepository>(
        () => UserRepository(
            supabaseAuthService: Get.find<SupabaseAuthService>()),
        fenix: true);

    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);

    // Controllers
    Get.put<AuthController>(AuthController());
    Get.put<LoginController>(LoginController());
    Get.put<RegisterController>(RegisterController());
    Get.lazyPut(
        () => SnapRepository(
              dio: Get.find<Dio>(),
            ),
        fenix: true);
    Get.lazyPut(
        () => SnapValidTokenController(
            snapRepository: Get.find<SnapRepository>()),
        fenix: true);

    Get.lazyPut(() => AdsManagerRepository(), fenix: true);
    Get.put(SnapAuthController());
    Get.lazyPut(() => SnapAccountsController(), fenix: true);
    Get.lazyPut(() => SnapOrganizationsController(), fenix: true);
  }
}

void _handleDioError(DioException error) {
  if (error.type == DioExceptionType.badResponse) {
    debugPrint(
        '[Error] Response error: ${error.response?.statusCode} - ${error.message}');
  } else if (error.type == DioExceptionType.connectionTimeout) {
    debugPrint('[Error] Connection timeout: ${error.message}');
  } else if (error.type == DioExceptionType.sendTimeout) {
    debugPrint('[Error] Send timeout: ${error.message}');
  } else if (error.type == DioExceptionType.receiveTimeout) {
    debugPrint('[Error] Receive timeout: ${error.message}');
  } else {
    debugPrint('[Error] Unexpected error: ${error.message}');
  }
}
