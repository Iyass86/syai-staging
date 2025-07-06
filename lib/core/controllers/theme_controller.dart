import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'themeMode';

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode =>
      _themeMode.value == ThemeMode.dark ||
      (_themeMode.value == ThemeMode.system && Get.isPlatformDarkMode);

  setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    _box.write(_key, mode.index);

    Get.changeThemeMode(mode);

    // Force rebuild of all GetBuilder widgets
    update();
    await Future.delayed(const Duration(milliseconds: 200));
    Get.forceAppUpdate();
  }

  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  void updateThemeMode() {
    final savedThemeIndex = _box.read(_key);
    if (savedThemeIndex != null) {
      _themeMode.value = ThemeMode.values[savedThemeIndex];
    } else {
      _themeMode.value = ThemeMode.system;
    }
    Get.changeThemeMode(_themeMode.value);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    updateThemeMode();
  }
}
