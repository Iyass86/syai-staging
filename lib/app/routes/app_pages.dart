import 'package:flutter_oauth_chat/app/ui/pages/snap_accounts_page.dart';
import 'package:flutter_oauth_chat/app/ui/pages/snap_auth_page.dart';
import 'package:flutter_oauth_chat/app/ui/pages/social_media_page.dart';
import 'package:flutter_oauth_chat/app/ui/pages/snap_organizations_page.dart';
import 'package:get/get.dart';

// Feature pages
import '../ui/pages/chat_page.dart';
import '../ui/pages/dashboard_page.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/register_page.dart';
import '../ui/pages/error/not_found_page.dart';
import '../ui/pages/oauth_callback_page.dart';

// Bindings
import '../bindings/chat_binding.dart';
import '../bindings/dashboard_binding.dart';

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
  ];
}
