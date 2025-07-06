import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/message_display_controller.dart';
import '../routes/app_routes.dart';

/// GuestGuard middleware for protecting guest-only routes (login, register)
/// Redirects authenticated users away from auth pages
class GuestGuard extends GetMiddleware {
  final String? routeKey;
  final String redirectTo;

  MessageDisplayController get _messageController =>
      Get.find<MessageDisplayController>();

  GuestGuard({
    this.routeKey,
    this.redirectTo = AppRoutes.dashboard,
  }) : super(priority: 0);

  @override
  RouteSettings? redirect(String? route) {
    try {
      // Check if AuthController is available
      if (Get.isRegistered<AuthController>()) {
        final authController = Get.find<AuthController>();

        // If user is already authenticated, redirect to dashboard or specified route
        if (authController.isAuthenticated.value) {
          debugPrint('Authenticated user trying to access guest route: $route');
          _messageController.displayInfo(
            'أنت مسجل دخول بالفعل.',
            duration: const Duration(seconds: 2),
          );
          return RouteSettings(
            name: redirectTo,
            arguments: {'from': route, 'reason': 'already_authenticated'},
          );
        }
      }

      debugPrint('GuestGuard passed for route: $route');
      return null; // Allow access to guest route
    } catch (e) {
      debugPrint('GuestGuard error: $e');
      // In case of error, allow access to avoid blocking login/register
      return null;
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('GuestGuard: Accessing guest page ${page?.name}');
    return super.onPageCalled(page);
  }
}
