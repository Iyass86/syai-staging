import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import '../core/controllers/theme_controller.dart';
import '../core/controllers/language_controller.dart';
import '../core/routes/app_pages.dart';
import '../core/routes/app_routes.dart';
import 'features/error/error/not_found_page.dart';
import '../core/translations/app_translations.dart';
import '../core/theme/app_theme.dart';
import '../core/services/browser_navigation_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
    WidgetsBinding.instance.addObserver(this);

    // Setup browser navigation for web
    if (kIsWeb) {
      BrowserNavigationService.setupBrowserNavigation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => GetBuilder<LanguageController>(
        builder: (languageController) => GetMaterialApp(
          title: 'SyAi - Revolutionary AI Assistant',
          initialRoute: AppRoutes.login,
          getPages: AppPages.routes,
          unknownRoute: GetPage(
            name: AppRoutes.notFound,
            page: () => const NotFoundPage(),
          ),
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          locale: languageController.locale,
          translations: AppTranslations(),
          fallbackLocale: const Locale('en', 'US'),
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
