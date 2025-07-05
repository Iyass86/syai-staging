import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../controllers/language_controller.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';
import '../ui/pages/error/not_found_page.dart';
import '../translations/app_translations.dart';
import 'theme/app_theme.dart';

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
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.themeMode,
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
