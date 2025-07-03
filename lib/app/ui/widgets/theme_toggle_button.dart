import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  final Color? iconColor;

  const ThemeToggleButton({Key? key, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: Get.find<ThemeController>(),
      builder: (controller) {
        return IconButton(
          icon: Icon(
            controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: iconColor,
          ),
          onPressed: controller.toggleTheme,
          tooltip: 'toggle_theme'.tr,
        );
      },
    );
  }
}
