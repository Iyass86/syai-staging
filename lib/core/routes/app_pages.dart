import 'package:flutter_oauth_chat/presentation/features/snap_integration/snap_accounts_page.dart';
import 'package:flutter_oauth_chat/presentation/features/snap_integration/snap_auth_page.dart';
import 'package:flutter_oauth_chat/presentation/features/social_media/social_media_page.dart';
import 'package:flutter_oauth_chat/presentation/features/snap_integration/snap_organizations_page.dart';
import 'package:flutter_oauth_chat/presentation/features/snap_integration/snap_oauth_callback_page.dart';
import 'package:flutter_oauth_chat/presentation/features/error/error_test_page.dart';
import 'package:flutter_oauth_chat/presentation/features/snap_integration/snap_pixel_setup_page.dart';
import 'package:flutter_oauth_chat/presentation/features/snap_integration/snap_pixels_page.dart';
import 'package:get/get.dart';

// Feature pages
import '../../presentation/features/chat/chat_page.dart';
import '../../presentation/features/dashboard/dashboard_page.dart';
import '../../presentation/features/auth/login_page.dart';
import '../../presentation/features/auth/register_page.dart';
import '../../presentation/features/error/error/not_found_page.dart';
import '../../presentation/features/auth/oauth_callback_page.dart';

// Bindings
import '../bindings/chat_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/snap_pixels_binding.dart';

// Middleware
import '../middleware/middleware_manager.dart';

import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      middlewares: [
        MiddlewareManager.guestOnly(AppRoutes.login),
      ],
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      middlewares: [
        MiddlewareManager.guestOnly(AppRoutes.register),
      ],
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      bindings: [ChatBinding()],
      preventDuplicates: true,
      middlewares: [
        MiddlewareManager.registeredOnly(AppRoutes.chat),
      ],
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      bindings: [DashboardBinding()],
      preventDuplicates: true,
      middlewares: [
        MiddlewareManager.guestFriendlyAuth(AppRoutes.dashboard),
      ],
    ),
    GetPage(
      name: AppRoutes.oauthCallback,
      page: () => const OAuthCallbackPage(),
      // No auth guard for callback page as it's part of auth flow
    ),
    GetPage(
      name: AppRoutes.snapOauthCallback,
      page: () => const SnapOAuthCallbackPage(),
      // No auth guard for callback page as it's part of auth flow
    ),
    GetPage(
      name: AppRoutes.notFound,
      page: () => const NotFoundPage(),
      // No auth guard for error pages
    ),
    GetPage(
      name: AppRoutes.snapAuth,
      page: () => const SnapAuthPage(),
      middlewares: [
        MiddlewareManager.registeredOnly(AppRoutes.snapAuth),
      ],
    ),
    GetPage(
      name: AppRoutes.socialMediaPage,
      page: () => const SocialMediaPage(),
      middlewares: [
        MiddlewareManager.registeredOnly(AppRoutes.socialMediaPage),
      ],
    ),
    GetPage(
      name: AppRoutes.snapAccounts,
      page: () => const SnapAccountsPage(),
      middlewares: [
        MiddlewareManager.registeredOnly(AppRoutes.snapAccounts),
      ],
    ),
    GetPage(
      name: AppRoutes.snapOrganizations,
      page: () => const SnapOrganizationsPage(),
      middlewares: [
        MiddlewareManager.registeredOnly(AppRoutes.snapOrganizations),
      ],
    ),
    GetPage(
      name: AppRoutes.errorTest,
      page: () => const ErrorTestPage(),
    ),
    GetPage(
      name: AppRoutes.snapPixelSetup,
      page: () {
        final clientId = Get.parameters['clientId'] ?? 'default-client';
        return SnapPixelSetupPage(clientId: clientId);
      },
      middlewares: [
        MiddlewareManager.registeredOnly(AppRoutes.snapPixelSetup),
      ],
    ),
    GetPage(
      name: AppRoutes.snapPixels,
      page: () => const SnapPixelsPage(),
      bindings: [SnapPixelsBinding()],
      middlewares: [
        MiddlewareManager.registeredOnly(AppRoutes.snapPixels),
      ],
    ),
  ];
}
