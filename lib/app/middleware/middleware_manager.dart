import '../middleware/auth_guard.dart';
import '../middleware/admin_guard.dart';
import '../middleware/guest_guard.dart';
import '../routes/app_routes.dart';

/// Centralized middleware configuration for the application
/// Provides predefined middleware configurations for different route types
class MiddlewareManager {
  // Standard authentication protection
  static AuthGuard standardAuth(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: false,
      );

  // Authentication with email verification required
  static AuthGuard verifiedAuth(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: true,
      );

  // Authentication with specific role requirements
  static AuthGuard roleBasedAuth(String routeKey, List<String> roles) =>
      AuthGuard(
        routeKey: routeKey,
        requiresVerification: true,
        requiredRoles: roles,
      );

  // Admin-only access
  static AdminGuard adminOnly(String routeKey) => AdminGuard(
        routeKey: routeKey,
        allowedRoles: ['admin', 'super_admin'],
      );

  // Super admin only access
  static AdminGuard superAdminOnly(String routeKey) => AdminGuard(
        routeKey: routeKey,
        allowedRoles: ['super_admin'],
      );

  // Guest-only access (redirects authenticated users)
  static GuestGuard guestOnly(String routeKey) => GuestGuard(
        routeKey: routeKey,
        redirectTo: AppRoutes.dashboard,
      );

  // Premium user access
  static AuthGuard premiumAuth(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: true,
        requiredRoles: ['premium', 'admin', 'super_admin'],
      );

  // Social media integration features
  static AuthGuard socialMediaAuth(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: true,
      );

  // Guest-friendly authentication (allows guests)
  static AuthGuard guestFriendlyAuth(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: false,
        allowGuests: true,
      );

  // Registered users only (no guests allowed)
  static AuthGuard registeredOnly(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: false,
        allowGuests: false,
      );

  // Verified users only (no guests allowed)
  static AuthGuard verifiedOnly(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: true,
        allowGuests: false,
      );

  // Premium features (verified users, no guests)
  static AuthGuard premiumOnly(String routeKey) => AuthGuard(
        routeKey: routeKey,
        requiresVerification: true,
        allowGuests: false,
        requiredRoles: ['premium', 'admin', 'super_admin'],
      );
}
