import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_auth_controller.dart';
import 'package:flutter_oauth_chat/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SnapAuthPage extends GetView<SnapAuthController> {
  const SnapAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    colorScheme.surface.withOpacity(0.95),
                    colorScheme.background.withOpacity(0.9),
                  ]
                : [
                    colorScheme.primary.withOpacity(0.08),
                    colorScheme.secondary.withOpacity(0.05),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width > 600 ? 64.0 : 24.0,
                  vertical: 32.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: _buildCard(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 8 : 16,
      shadowColor: colorScheme.shadow.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo and branding
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.ads_click_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'connect_snap_account'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'setup_advertising_credentials'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildRegisterForm(),
              const SizedBox(height: 32),
              _buildDivider(),
              const SizedBox(height: 32),
              _buildOAuthSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Client ID Field
              _buildFormFieldWithInfo(
                controller: controller.clientIdController,
                labelText: 'client_id'.tr,
                hintText: 'enter_client_id'.tr,
                prefixIcon: Icons.app_registration_outlined,
                validator: (value) => _requiredValidator(value, 'client_id'.tr),
                colorScheme: colorScheme,
                infoText: 'client_id_info'.tr,
              ),
              const SizedBox(height: 24),

              // Client Secret Field
              _buildFormFieldWithInfo(
                controller: controller.clientSecretController,
                labelText: 'client_secret'.tr,
                hintText: 'enter_client_secret'.tr,
                prefixIcon: Icons.security_outlined,
                validator: (value) =>
                    _requiredValidator(value, 'client_secret'.tr),
                colorScheme: colorScheme,
                infoText: 'client_secret_info'.tr,
              ),
              const SizedBox(height: 24),
              // Redirect URI information
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withOpacity(0.3),
                      colorScheme.secondaryContainer.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.link_outlined,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'redirect_uri'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showInfoDialog(
                              'redirect_uri'.tr, 'redirect_uri_info'.tr),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.code_outlined,
                            size: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              SnapAuthController.defaultRedirectUri,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.9),
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _copyToClipboard(
                                SnapAuthController.defaultRedirectUri),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.copy_outlined,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: colorScheme.primary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'use_this_uri_in_snap_console'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                  height: 1.3,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // URL Field
              // _buildFormField(
              //   controller: controller.redirectUriController,
              //   labelText: 'url'.tr,
              //   hintText: 'enter_redirect_url'.tr,
              //   prefixIcon: Icons.link_outlined,
              //   validator: (value) => _requiredValidator(value, 'url'.tr),
              //   colorScheme: colorScheme,
              // ),

              // // Redirect URI Field
              // _buildFormField(
              //   controller: controller.urlCodeController,
              //   labelText: 'redirect_uri'.tr,
              //   hintText: 'enter_redirect_uri_code'.tr,
              //   prefixIcon: Icons.code_outlined,
              //   onChanged: (String? enteredUrl) {
              //     final String? code =
              //         controller.extractQueryParameter(enteredUrl, 'code');
              //     controller.urlCodeController.text = code ?? '';
              //     return null;
              //   },
              //   validator: (value) =>
              //       _requiredValidator(value, 'redirect_uri'.tr),
              //   colorScheme: colorScheme,
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormFieldWithInfo({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    String? Function(String?)? onChanged,
    required ColorScheme colorScheme,
    required String infoText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                labelText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _showInfoDialog(labelText, infoText),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, color: colorScheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: colorScheme.outline.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
          validator: validator,
        ),
      ],
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'copied'.tr,
      'redirect_uri_copied'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.check_circle_outline,
        color: Get.theme.colorScheme.onPrimary,
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Get.theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Get.theme.colorScheme.onSurface.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'close'.tr,
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${'is_required'.tr}';
    }
    return null;
  }

  Widget _buildDivider() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.outline.withOpacity(0.0),
                        colorScheme.outline.withOpacity(0.5),
                        colorScheme.outline.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'or'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.outline.withOpacity(0.0),
                        colorScheme.outline.withOpacity(0.5),
                        colorScheme.outline.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOAuthSignUp() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Obx(() {
          return Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                if (controller.isLoading.value) return;
                controller.initiateOAuthFlow();
              },
              icon: controller.isLoading.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    )
                  : Icon(
                      Icons.login_outlined,
                      color: colorScheme.onSecondaryContainer,
                    ),
              label: Text(
                'connect_account'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
