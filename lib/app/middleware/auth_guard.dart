import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AuthGuard extends GetMiddleware {
  final String? routeKey;
  final bool requiresVerification;
  final List<String>? requiredRoles;
  final bool allowGuests;

  AuthGuard({
    this.routeKey,
    this.requiresVerification = false,
    this.requiredRoles,
    this.allowGuests = true,
  }) : super(priority: 1);

  @override
  RouteSettings? redirect(String? route) {
    try {
      // Check if AuthController is available
      if (!Get.isRegistered<AuthController>()) {
        debugPrint('AuthController not registered, redirecting to login');
        return RouteSettings(
          name: AppRoutes.login,
          arguments: {
            'from': route,
            'key': routeKey,
            'reason': 'controller_not_found'
          },
        );
      }

      final authController = Get.find<AuthController>();
      final storageService = Get.find<StorageService>();

      // Primary authentication check
      if (!authController.isAuthenticated.value) {
        debugPrint('User not authenticated, redirecting to login');
        return RouteSettings(
          name: AppRoutes.login,
          arguments: {
            'from': route,
            'key': routeKey,
            'reason': 'not_authenticated'
          },
        );
      }

      // Secondary check - validate stored credentials
      final token = storageService.getAccessToken();
      final user = storageService.getUser();

      if (token == null || user == null) {
        debugPrint('Missing stored credentials, redirecting to login');
        authController.logout(); // Clear invalid session
        return RouteSettings(
          name: AppRoutes.login,
          arguments: {
            'from': route,
            'key': routeKey,
            'reason': 'missing_credentials'
          },
        );
      }

      // Check if user verification is required
      final userMetadata = user.userMetadata;
      final isGuest = userMetadata?['is_guest'] == true;

      // Skip email verification for guest users
      if (requiresVerification && !isGuest && user.emailConfirmedAt == null) {
        debugPrint('User email not verified, access denied');
        Get.snackbar(
          'Email Verification Required',
          'Please verify your email before accessing this feature.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
        return RouteSettings(
          name: AppRoutes.login,
          arguments: {
            'from': route,
            'key': routeKey,
            'reason': 'email_not_verified'
          },
        );
      }

      // Check if guests are allowed on this route
      if (isGuest && !allowGuests) {
        debugPrint('Guest access not allowed for route: $route');
        Get.snackbar(
          'Account Required',
          'Please create an account to access this feature.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () => Get.toNamed(AppRoutes.register),
            child: const Text('Sign Up'),
          ),
        );
        return RouteSettings(
          name: AppRoutes.dashboard,
          arguments: {'reason': 'guest_not_allowed'},
        );
      }

      // Check role-based access if roles are specified
      if (requiredRoles != null && requiredRoles!.isNotEmpty) {
        final userRole = userMetadata?['role'] as String?;

        if (userRole == null || !requiredRoles!.contains(userRole)) {
          debugPrint('Insufficient permissions for route: $route');

          // Special message for guests
          if (isGuest) {
            Get.snackbar(
              'Account Required',
              'Please create an account to access premium features.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 5),
              mainButton: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.register),
                child: const Text('Upgrade'),
              ),
            );
          } else {
            Get.snackbar(
              'Access Denied',
              'You don\'t have permission to access this feature.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          }

          return RouteSettings(
            name: AppRoutes.dashboard,
            arguments: {'reason': 'insufficient_permissions'},
          );
        }
      }

      debugPrint('AuthGuard passed for route: $route');
      return null; // Allow access
    } catch (e) {
      debugPrint('AuthGuard error: $e');
      return RouteSettings(
        name: AppRoutes.login,
        arguments: {'from': route, 'key': routeKey, 'reason': 'auth_error'},
      );
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('AuthGuard: Accessing page ${page?.name}');
    return super.onPageCalled(page);
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    debugPrint('AuthGuard: Starting bindings for protected route');
    return super.onBindingsStart(bindings);
  }
}
