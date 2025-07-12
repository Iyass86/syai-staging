import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

// Conditional import for web
import 'dart:html' as html show window;

/// Service to handle browser navigation properly in Flutter web
/// This service ensures that browser back/forward buttons work correctly
class BrowserNavigationService extends GetxService {
  /// Navigate to a route while preserving browser history
  /// This should be used for normal navigation where back button should work
  static void navigateTo(String route, {dynamic arguments}) {
    if (kIsWeb) {
      // Update browser URL without replacing history
      html.window.history.pushState(null, '', route);
    }
    Get.toNamed(route, arguments: arguments);
  }

  /// Replace current route without adding to history
  /// Use this when you want to replace the current page
  static void replaceTo(String route, {dynamic arguments}) {
    if (kIsWeb) {
      // Replace current browser URL
      html.window.history.replaceState(null, '', route);
    }
    Get.offNamed(route, arguments: arguments);
  }

  /// Clear all history and navigate (for auth flows)
  /// Use this for login/logout flows where you want to clear navigation history
  static void resetTo(String route, {dynamic arguments}) {
    Get.offAllNamed(route, arguments: arguments);
  }

  /// Navigate back if possible, otherwise go to default route
  static void goBack({String? fallbackRoute}) {
    if (Navigator.canPop(Get.context!)) {
      Get.back();
    } else {
      // If can't go back, navigate to fallback route or dashboard
      final route = fallbackRoute ?? AppRoutes.dashboard;
      Get.offAllNamed(route);
    }
  }

  /// Handle browser back button event
  static void handleBrowserBack() {
    if (Navigator.canPop(Get.context!)) {
      Get.back();
    } else {
      // Navigate to appropriate fallback based on current route
      final currentRoute = Get.currentRoute;

      if (currentRoute == AppRoutes.login ||
          currentRoute == AppRoutes.register) {
        // Can't go back from auth pages
        return;
      } else {
        // Go to dashboard as fallback
        Get.offAllNamed(AppRoutes.dashboard);
      }
    }
  }

  /// Check if we can navigate back
  static bool canGoBack() {
    return Navigator.canPop(Get.context!);
  }

  /// Setup browser navigation event listeners
  static void setupBrowserNavigation() {
    if (kIsWeb) {
      html.window.addEventListener('popstate', (event) {
        handleBrowserBack();
      });
    }
  }

  /// Navigate to a route with proper history management based on context
  static void smartNavigate(
    String route, {
    dynamic arguments,
    bool shouldClearHistory = false,
    bool shouldReplaceCurrentPage = false,
  }) {
    if (shouldClearHistory) {
      resetTo(route, arguments: arguments);
    } else if (shouldReplaceCurrentPage) {
      replaceTo(route, arguments: arguments);
    } else {
      navigateTo(route, arguments: arguments);
    }
  }

  /// Navigate between feature pages (preserves history)
  static void navigateToFeature(String route, {dynamic arguments}) {
    navigateTo(route, arguments: arguments);
  }

  /// Navigate after authentication (replaces auth page)
  static void navigateAfterAuth(String route, {dynamic arguments}) {
    replaceTo(route, arguments: arguments);
  }

  /// Navigate for logout (clears all history)
  static void navigateForLogout(String route, {dynamic arguments}) {
    resetTo(route, arguments: arguments);
  }

  /// Navigate for error recovery (clears history)
  static void navigateForError(String route, {dynamic arguments}) {
    resetTo(route, arguments: arguments);
  }
}
