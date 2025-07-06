import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/message_display_controller.dart';
import '../routes/app_routes.dart';
import '../services/storage_service.dart';

/// AdminGuard middleware for protecting admin-only routes
/// Extends AuthGuard functionality with role-based access control
class AdminGuard extends GetMiddleware {
  final String? routeKey;
  final List<String> allowedRoles;

  MessageDisplayController get _messageController =>
      Get.find<MessageDisplayController>();

  AdminGuard({
    this.routeKey,
    this.allowedRoles = const ['admin', 'super_admin'],
  }) : super(priority: 2); // Higher priority than AuthGuard

  @override
  RouteSettings? redirect(String? route) {
    try {
      // First check authentication
      if (!Get.isRegistered<AuthController>()) {
        debugPrint('AuthController not registered for admin route');
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

      if (!authController.isAuthenticated.value) {
        debugPrint('User not authenticated for admin route');
        return RouteSettings(
          name: AppRoutes.login,
          arguments: {
            'from': route,
            'key': routeKey,
            'reason': 'not_authenticated'
          },
        );
      }

      // Check stored credentials
      final user = storageService.getUser();
      if (user == null) {
        debugPrint('No user data found for admin route');
        authController.logout();
        return RouteSettings(
          name: AppRoutes.login,
          arguments: {
            'from': route,
            'key': routeKey,
            'reason': 'missing_user_data'
          },
        );
      }

      // Check admin role
      final userMetadata = user.userMetadata;
      final userRole = userMetadata?['role'] as String?;

      if (userRole == null || !allowedRoles.contains(userRole)) {
        debugPrint('Insufficient admin permissions for route: $route');
        _messageController.displayError(
          'مطلوبة صلاحيات المدير للوصول إلى هذه الميزة.',
          duration: const Duration(seconds: 5),
        );
        return RouteSettings(
          name: AppRoutes.dashboard,
          arguments: {'reason': 'insufficient_admin_permissions'},
        );
      }

      debugPrint('AdminGuard passed for route: $route');
      return null; // Allow access
    } catch (e) {
      debugPrint('AdminGuard error: $e');
      return RouteSettings(
        name: AppRoutes.login,
        arguments: {
          'from': route,
          'key': routeKey,
          'reason': 'admin_auth_error'
        },
      );
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('AdminGuard: Accessing admin page ${page?.name}');
    return super.onPageCalled(page);
  }
}
