import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/language_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/message_display_controller.dart';
import '../../services/export_service.dart';

class _NavigationItem {
  final String title;
  final IconData icon;
  final String? route;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  _NavigationItem(this.title, this.icon, this.route, this.color,
      {this.subtitle, this.onTap});
}

class AppNavigationHelper {
  static Widget buildNavigationDrawer() {
    return GetBuilder<ThemeController>(
      builder: (themeController) => Drawer(
        width: 300,
        backgroundColor: Get.theme.colorScheme.surface,
        child: SafeArea(
          child: Column(
            children: [
              // Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    const SizedBox(height: 8),
                    _buildSectionTitle('main_navigation'.tr),
                    const SizedBox(height: 8),
                    ..._getMainNavigationItems()
                        .map((item) => _buildNavigationTile(item)),
                    const SizedBox(height: 24),
                    _buildSectionTitle('quick_actions'.tr),
                    _buildQuickActionTile(
                      'refresh_data'.tr,
                      Icons.refresh_rounded,
                      Colors.teal,
                      () {
                        Get.back();
                        // Get the dashboard controller and refresh data
                        try {
                          final dashboardController =
                              Get.find<DashboardController>();
                          dashboardController.refreshData();
                          Get.find<MessageDisplayController>().displaySuccess(
                            'تم تحديث بيانات لوحة التحكم',
                            duration: const Duration(seconds: 2),
                          );
                        } catch (e) {
                          Get.find<MessageDisplayController>().displayError(
                            'خطأ: $e',
                            duration: const Duration(seconds: 3),
                          );
                        }
                      },
                    ),
                    _buildQuickActionTile(
                      'export_data'.tr,
                      Icons.download_rounded,
                      Colors.blue,
                      () {
                        Get.back();
                        _showExportDialog();
                      },
                    ),
                    _buildQuickActionTile(
                      'contact_support'.tr,
                      Icons.support_agent_rounded,
                      Colors.orange,
                      () {
                        Get.back();
                        _showContactDialog();
                      },
                    ),
                  ],
                ),
              ),

              // Footer Section
              _buildDrawerFooter(),
            ],
          ),
        ),
      ),
    );
  }

  static List<_NavigationItem> _getMainNavigationItems() {
    return [
      _NavigationItem(
        'dashboard'.tr,
        Icons.dashboard_rounded,
        AppRoutes.dashboard,
        Colors.blue,
        subtitle: 'performance_overview'.tr,
        onTap: () {
          Get.back(); // Close drawer
          // Switch to overview when navigating to dashboard
          final dashboardController = Get.find<DashboardController>();
          dashboardController.switchToOverview();
          Get.offNamed(AppRoutes.dashboard);
        },
      ),
      _NavigationItem(
        'social_media'.tr,
        Icons.share_rounded,
        null, // No route - stay on dashboard
        Colors.purple,
        subtitle: 'social_campaigns'.tr,
        onTap: () {
          Get.back(); // Close drawer
          // Switch to social media view in dashboard
          final dashboardController = Get.find<DashboardController>();
          dashboardController.switchToSocialMedia();
        },
      ),
    ];
  }

  static Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Get.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }

  static Widget _buildNavigationTile(_NavigationItem item) {
    // Check if this is the current route OR if it's the dashboard and matches current view
    bool isCurrentItem = false;

    if (item.route != null && Get.currentRoute == item.route) {
      // This is the current route
      if (item.route == AppRoutes.dashboard) {
        // For dashboard route, check if the view matches
        try {
          final dashboardController = Get.find<DashboardController>();
          if (item.title == 'dashboard'.tr) {
            isCurrentItem = dashboardController.currentView.value ==
                DashboardController.OVERVIEW_VIEW;
          } else if (item.title == 'social_media'.tr) {
            isCurrentItem = dashboardController.currentView.value ==
                DashboardController.SOCIAL_MEDIA_VIEW;
          }
        } catch (e) {
          isCurrentItem = true; // Fallback to route-based selection
        }
      } else {
        isCurrentItem = true;
      }
    } else if (item.route == null && Get.currentRoute == AppRoutes.dashboard) {
      // This is a dashboard view item (like social media)
      try {
        final dashboardController = Get.find<DashboardController>();
        if (item.title == 'social_media'.tr) {
          isCurrentItem = dashboardController.currentView.value ==
              DashboardController.SOCIAL_MEDIA_VIEW;
        }
      } catch (e) {
        isCurrentItem = false;
      }
    }

    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        // Recalculate selection state
        if (Get.currentRoute == AppRoutes.dashboard) {
          if (item.title == 'dashboard'.tr) {
            isCurrentItem = dashboardController.currentView.value ==
                DashboardController.OVERVIEW_VIEW;
          } else if (item.title == 'social_media'.tr) {
            isCurrentItem = dashboardController.currentView.value ==
                DashboardController.SOCIAL_MEDIA_VIEW;
          }
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isCurrentItem
                  ? null
                  : () {
                      if (item.onTap != null) {
                        // Use custom onTap action
                        item.onTap!();
                      } else if (item.route != null) {
                        // Use route navigation
                        Get.back();
                        Get.offNamed(item.route!);
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isCurrentItem
                      ? item.color.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isCurrentItem
                      ? Border.all(
                          color: item.color.withOpacity(0.3),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCurrentItem
                            ? item.color.withOpacity(0.2)
                            : item.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: isCurrentItem
                            ? item.color
                            : item.color.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: isCurrentItem
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isCurrentItem
                                  ? item.color
                                  : Get.theme.colorScheme.onSurface,
                            ),
                          ),
                          if (item.subtitle != null)
                            Text(
                              item.subtitle!,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Get.theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isCurrentItem)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: item.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildQuickActionTile(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Divider(
            color: Get.theme.colorScheme.outline.withOpacity(0.2),
          ),
          const SizedBox(height: 12),

          // Settings, Theme, and Language Toggle
          Row(
            children: [
              Expanded(
                child: _buildFooterButton(
                  'theme'.tr,
                  Icons.palette_rounded,
                  () {
                    Get.back();
                    _showThemeDialog();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFooterButton(
                  'language'.tr,
                  Icons.language_rounded,
                  () {
                    Get.back();
                    _showLanguageDialog();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Logout Button
          Container(
            width: double.infinity,
            child: _buildLogoutButton(),
          ),

          const SizedBox(height: 16),

          // App Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'app_version'.tr,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFooterButton(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Get.theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showThemeDialog() {
    Get.dialog(
      GetBuilder<ThemeController>(
        builder: (controller) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.palette_rounded,
                  color: Get.theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'theme_settings'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'choose_theme_mode'.tr,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),

              // Light Theme Option
              _buildThemeOption(
                title: 'light_theme'.tr,
                subtitle: 'light_theme_desc'.tr,
                icon: Icons.light_mode_rounded,
                themeMode: ThemeMode.light,
                currentMode: controller.themeMode,
                onChanged: (value) {
                  Get.back();
                  if (value != null) {
                    controller.setThemeMode(value);
                  }
                },
              ),

              const SizedBox(height: 12),

              // Dark Theme Option
              _buildThemeOption(
                title: 'dark_theme'.tr,
                subtitle: 'dark_theme_desc'.tr,
                icon: Icons.dark_mode_rounded,
                themeMode: ThemeMode.dark,
                currentMode: controller.themeMode,
                onChanged: (value) {
                  Get.back();
                  if (value != null) {
                    controller.setThemeMode(value);
                  }
                },
              ),

              const SizedBox(height: 12),

              // System Theme Option
              _buildThemeOption(
                title: 'system_theme'.tr,
                subtitle: 'system_theme_desc'.tr,
                icon: Icons.settings_system_daydream_rounded,
                themeMode: ThemeMode.system,
                currentMode: controller.themeMode,
                onChanged: (value) {
                  Get.back();
                  if (value != null) {
                    controller.setThemeMode(value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: Get.theme.colorScheme.primary,
              ),
              label: Text(
                'done'.tr,
                style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode themeMode,
    required ThemeMode currentMode,
    required ValueChanged<ThemeMode?> onChanged,
  }) {
    final isSelected = currentMode == themeMode;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Get.theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Get.theme.colorScheme.primary.withOpacity(0.3)
              : Get.theme.colorScheme.outline.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<ThemeMode>(
        value: themeMode,
        groupValue: currentMode,
        onChanged: onChanged,
        activeColor: Get.theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? Get.theme.colorScheme.primary.withOpacity(0.2)
                : Get.theme.colorScheme.surfaceContainerHighest
                    .withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? Get.theme.colorScheme.primary
                : Get.theme.colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Get.theme.colorScheme.primary
                : Get.theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Get.textTheme.bodySmall?.copyWith(
            color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  static void _showExportDialog() {
    Get.dialog(
      GetBuilder<ThemeController>(
        builder: (controller) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.download_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'export_title'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'choose_export_format'.tr,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              _buildExportOption(
                'Export as XLSX',
                'Export dashboard data as Excel spreadsheet',
                Icons.table_chart_rounded,
                Colors.green,
                () async {
                  Get.back();
                  _showLoadingDialog('Generating XLSX...');
                  try {
                    await ExportService.exportAsXLSX();
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displaySuccess(
                      'تم تصدير ملف XLSX بنجاح!',
                      duration: const Duration(seconds: 3),
                    );
                  } catch (e) {
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displayError(
                      'فشل تصدير XLSX: $e',
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildExportOption(
                'export_pdf'.tr,
                'export_pdf_desc'.tr,
                Icons.picture_as_pdf_rounded,
                Colors.red,
                () async {
                  Get.back();
                  _showLoadingDialog('generating_pdf'.tr);
                  try {
                    await ExportService.exportAsPDF();
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displaySuccess(
                      'تم تحميل ملف PDF بنجاح!',
                      duration: const Duration(seconds: 3),
                    );
                  } catch (e) {
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displayError(
                      'فشل تصدير PDF: $e',
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildExportOption(
                'export_json'.tr,
                'export_json_desc'.tr,
                Icons.code_rounded,
                Colors.purple,
                () async {
                  Get.back();
                  _showLoadingDialog('generating_json'.tr);
                  try {
                    await ExportService.exportAsJSON();
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displaySuccess(
                      'تم تحميل ملف JSON بنجاح!',
                      duration: const Duration(seconds: 3),
                    );
                  } catch (e) {
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displayError(
                      'فشل تصدير JSON: $e',
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildExportOption(
                'Test Export',
                'Test download functionality with simple file',
                Icons.bug_report_rounded,
                Colors.orange,
                () async {
                  Get.back();
                  _showLoadingDialog('Testing export...');
                  try {
                    await ExportService.testExport();
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displaySuccess(
                      'تم اختبار التصدير بنجاح!',
                      duration: const Duration(seconds: 3),
                    );
                  } catch (e) {
                    Get.back(); // Close loading dialog
                    Get.find<MessageDisplayController>().displayError(
                      'فشل اختبار التصدير: $e',
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              label: Text(
                'cancel'.tr,
                style: TextStyle(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildExportOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Get.theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showContactDialog() {
    Get.dialog(
      GetBuilder<ThemeController>(
        builder: (controller) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'contact_title'.tr,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'contact_desc'.tr,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              _buildContactItem(
                '📧 ${'email'.tr}',
                'marketing_email'.tr,
                Icons.email_rounded,
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                '📞 ${'phone'.tr}',
                'marketing_phone'.tr,
                Icons.phone_rounded,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                '🌐 ${'website'.tr}',
                'marketing_website'.tr,
                Icons.web_rounded,
                Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                '💬 ${'slack'.tr}',
                'marketing_slack'.tr,
                Icons.chat_rounded,
                Colors.orange,
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              label: Text(
                'close'.tr,
                style: TextStyle(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildContactItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show loading dialog during export operations
  static void _showLoadingDialog(String message) {
    Get.dialog(
      GetBuilder<ThemeController>(
        builder: (controller) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'please_wait'.tr,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show language selection dialog
  static void _showLanguageDialog() {
    final languageController = Get.find<LanguageController>();

    Get.dialog(
      GetBuilder<ThemeController>(
        builder: (themeController) => GetBuilder<LanguageController>(
          builder: (langController) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: Get.theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'select_language'.tr,
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'choose_preferred_language'.tr,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 20),

                // Language options
                ...languageController.languages.map((language) {
                  final isSelected =
                      langController.locale.languageCode == language['code'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Get.theme.colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Get.theme.colorScheme.primary.withOpacity(0.3)
                            : Get.theme.colorScheme.outline.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.back();
                        languageController.changeLanguage(
                          language['code'],
                          language['countryCode'],
                        );
                        Get.find<MessageDisplayController>().displaySuccess(
                          'تم تغيير اللغة إلى ${language['nameNative']}',
                          duration: const Duration(seconds: 2),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Get.theme.colorScheme.primary.withOpacity(0.2)
                              : Get.theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          language['flag'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(
                        language['nameNative'],
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Get.theme.colorScheme.primary
                              : Get.theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        language['name'],
                        style: Get.textTheme.bodySmall?.copyWith(
                          color:
                              Get.theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Get.theme.colorScheme.primary,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: Get.theme.colorScheme.primary,
                ),
                label: Text(
                  'done'.tr,
                  style: TextStyle(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLogoutButton() {
    return GetBuilder<AuthController>(
      builder: (authController) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => authController.logout(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'logout'.tr,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
