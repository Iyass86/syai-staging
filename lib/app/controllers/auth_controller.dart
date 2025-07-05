// File: lib/app/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/data/models/ads_manager.dart';
import 'package:flutter_oauth_chat/app/repositories/ads_managers_repository.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_oauth_chat/app/repositories/user_repository.dart';
import 'package:flutter_oauth_chat/app/services/supabase_service.dart';

import '../routes/app_routes.dart';
import '../services/storage_service.dart';
import 'message_display_controller.dart';

class AuthController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();
  MessageDisplayController get _messageController =>
      Get.find<MessageDisplayController>();

  final isAuthenticated = false.obs;
  final currentUser = Rxn<User>();
  final accessToken = RxnString();
  final isLoading = false.obs;
  User? get user => storageService.getUser();
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  setUser(User user) {
    currentUser.value = user;
    storageService.saveUser(user.toJson());
  }

  void _checkAuthStatus() {
    final token = storageService.getAccessToken();
    final userData = storageService.getUser();

    if (token != null && userData != null) {
      accessToken.value = token;
      currentUser.value = userData;
      isAuthenticated.value = true;
    }
  }

  Future<void> handleOAuthCallback(
      String? code, String? state, String? error) async {}

  Future<void> loginWithEmail(String email, String password) async {
    isLoading.value = true;
    Get.find<UserRepository>()
        .signIn(
      email: email.trim(),
      password: password,
    )
        .then((result) {
      // Handle successful login
      AuthResponse authResponse = result as AuthResponse;
      Get.find<StorageService>().saveUser(authResponse.user?.toJson() ?? {});
      Get.find<StorageService>()
          .saveAccessToken(authResponse.session?.accessToken ?? '');
      isLoading.value = false;

      debugPrint('Login successful: ${authResponse.session?.accessToken}');
      isAuthenticated.value = true;
      _saveStoredCredentials(authResponse.user?.id);
      Get.offNamed(AppRoutes.dashboard);
    }).catchError((error) {
      // Handle login error
      if (error is SupabaseException) {
        _messageController
            .displayError('خطأ في تسجيل الدخول: ${error.message}');
      }
      isLoading.value = false;
      debugPrint('Error during registration: ${error.toString()}');
    }).whenComplete(() => isLoading.value = false);
  }

  _saveStoredCredentials(id) async {
    AdsManagerModel? adsManager =
        await Get.find<AdsManagerRepository>().getById(key: "UID", id: id);
    if (adsManager != null) {
      await storageService.saveAdsManager(adsManager.toJson());
      debugPrint('AdsManager saved: ${adsManager.toJson()}');
    } else {
      debugPrint('No AdsManager found for ID: $id');
    }
  }

  Future<void> register(String name, String email, String password) async {
    isLoading.value = true;

    Get.find<UserRepository>()
        .signUp(
      email: email,
      password: password,
      name: name,
    )
        .then((result) {
      AuthResponse authResponse = result as AuthResponse;
      Get.find<StorageService>().saveUser(authResponse.user?.toJson() ?? {});
      Get.find<StorageService>()
          .saveAccessToken(authResponse.session?.accessToken ?? '');
      isLoading.value = false;
      debugPrint(
          'Registration successful: ${authResponse.session?.accessToken}');
      isAuthenticated.value = true;
      Get.toNamed(AppRoutes.dashboard);
    }).catchError((error) {
      if (error is SupabaseException) {
        _messageController.displayError('خطأ في التسجيل: ${error.message}');
      }
      isLoading.value = false;
      debugPrint('Error during registration: ${error.toString()}');
    });
  }

  void logout() {
    final wasGuest = isGuest;

    isAuthenticated.value = false;
    currentUser.value = null;
    accessToken.value = null;
    isGuestUser.value = false;

    storageService.removeAccessToken();
    storageService.removeRefreshToken();
    storageService.removeUser();

    // Only call signOut for real users, not guests
    if (!wasGuest) {
      Get.find<UserRepository>().signOut();
    }

    Get.offAllNamed(AppRoutes.login);
  }

  // Guest account functionality
  final isGuestUser = false.obs;

  /// Login as a guest user with limited functionality
  Future<void> loginAsGuest() async {
    isLoading.value = true;

    try {
      // Create a mock guest user
      final guestUser = _createGuestUser();

      // Save guest session data
      storageService.saveUser(guestUser.toJson());
      storageService.saveAccessToken(
          'guest_token_${DateTime.now().millisecondsSinceEpoch}');

      // Update authentication state
      currentUser.value = guestUser;
      isAuthenticated.value = true;
      isGuestUser.value = true;

      debugPrint('Guest login successful');

      // Show guest mode notification
      _messageController.displayWarning(
          'أنت مسجل دخول كضيف. بعض الميزات قد تكون محدودة.',
          duration: const Duration(seconds: 4));

      // Navigate to dashboard
      Get.offNamed(AppRoutes.dashboard);
    } catch (error) {
      debugPrint('Error during guest login: ${error.toString()}');
      _messageController
          .displayError('فشل تسجيل دخول الضيف، يرجى المحاولة مرة أخرى.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a mock guest user
  User _createGuestUser() {
    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';

    return User(
      id: guestId,
      appMetadata: {
        'provider': 'guest',
        'providers': ['guest'],
      },
      userMetadata: {
        'role': 'guest',
        'is_guest': true,
        'display_name': 'Guest User',
        'avatar_url': null,
      },
      aud: 'authenticated',
      email: 'guest@local.app',
      phone: null,
      createdAt: DateTime.now().toIso8601String(),
      confirmedAt: DateTime.now().toIso8601String(),
      emailConfirmedAt: DateTime.now().toIso8601String(),
      phoneConfirmedAt: null,
      lastSignInAt: DateTime.now().toIso8601String(),
      role: 'authenticated',
      updatedAt: DateTime.now().toIso8601String(),
      identities: [],
      factors: [],
    );
  }

  /// Check if current user is a guest
  bool get isGuest =>
      isGuestUser.value || currentUser.value?.userMetadata?['is_guest'] == true;

  /// Upgrade guest account to regular account
  Future<void> upgradeGuestAccount(
      String email, String password, String name) async {
    if (!isGuest) return;

    isLoading.value = true;

    try {
      // Register new account
      await register(name, email, password);

      // Clear guest status
      isGuestUser.value = false;

      _messageController.displaySuccess('تم ترقية حساب الضيف بنجاح!');
    } catch (error) {
      debugPrint('Error upgrading guest account: ${error.toString()}');
      _messageController
          .displayError('فشل ترقية حساب الضيف، يرجى المحاولة مرة أخرى.');
    } finally {
      isLoading.value = false;
    }
  }
}
