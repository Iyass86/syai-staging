import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  final _key = 'language';

  final Rx<Locale> _locale = const Locale('en', 'US').obs;

  Locale get locale => _locale.value;

  // Available languages
  final List<Map<String, dynamic>> languages = [
    {
      'name': 'English',
      'nameNative': 'English',
      'code': 'en',
      'countryCode': 'US',
      'flag': '🇺🇸',
    },
    {
      'name': 'Arabic',
      'nameNative': 'العربية',
      'code': 'ar',
      'countryCode': 'SA',
      'flag': '🇸🇦',
    },
  ];

  String get currentLanguageName {
    final current = languages.firstWhere(
      (lang) => lang['code'] == _locale.value.languageCode,
      orElse: () => languages.first,
    );
    return current['nameNative'];
  }

  String get currentLanguageFlag {
    final current = languages.firstWhere(
      (lang) => lang['code'] == _locale.value.languageCode,
      orElse: () => languages.first,
    );
    return current['flag'];
  }

  bool get isRTL => _locale.value.languageCode == 'ar';

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    final newLocale = Locale(languageCode, countryCode);
    _locale.value = newLocale;

    // Save to storage
    _box.write(_key, '${languageCode}_$countryCode');

    // Update GetX locale
    Get.updateLocale(newLocale);

    // Update controller
    update();
    // Force rebuild of all GetBuilder widgets
    await Future.delayed(const Duration(milliseconds: 600));
    Get.forceAppUpdate();
  }

  void loadSavedLanguage() {
    final savedLanguage = _box.read(_key);
    if (savedLanguage != null) {
      final parts = savedLanguage.split('_');
      if (parts.length == 2) {
        _locale.value = Locale(parts[0], parts[1]);
        Get.updateLocale(_locale.value);
      }
    } else {
      // Default to device locale if available, otherwise English
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null) {
        final supportedLanguage = languages.firstWhere(
          (lang) => lang['code'] == deviceLocale.languageCode,
          orElse: () => languages.first,
        );
        _locale.value =
            Locale(supportedLanguage['code'], supportedLanguage['countryCode']);
        Get.updateLocale(_locale.value);
      }
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }
}
