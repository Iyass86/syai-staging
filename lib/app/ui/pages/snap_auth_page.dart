import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/controllers/snap_controllers/snap_auth_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/register_controller.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

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
              _buildFormField(
                controller: controller.clientIdController,
                labelText: 'client_id'.tr,
                hintText: 'enter_client_id'.tr,
                prefixIcon: Icons.app_registration_outlined,
                validator: (value) => _requiredValidator(value, 'client_id'.tr),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),

              // Client Secret Field
              _buildFormField(
                controller: controller.clientSecretController,
                labelText: 'client_secret'.tr,
                hintText: 'enter_client_secret'.tr,
                prefixIcon: Icons.security_outlined,
                validator: (value) =>
                    _requiredValidator(value, 'client_secret'.tr),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),

              // URL Field
              _buildFormField(
                controller: controller.redirectUriController,
                labelText: 'url'.tr,
                hintText: 'enter_redirect_url'.tr,
                prefixIcon: Icons.link_outlined,
                validator: (value) => _requiredValidator(value, 'url'.tr),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),

              // Redirect URI Field
              _buildFormField(
                controller: controller.urlCodeController,
                labelText: 'redirect_uri'.tr,
                hintText: 'enter_redirect_uri_code'.tr,
                prefixIcon: Icons.code_outlined,
                onChanged: (String? enteredUrl) {
                  final String? code =
                      controller.extractQueryParameter(enteredUrl, 'code');
                  controller.urlCodeController.text = code ?? '';
                  return null;
                },
                validator: (value) =>
                    _requiredValidator(value, 'redirect_uri'.tr),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    String? Function(String?)? onChanged,
    required ColorScheme colorScheme,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
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
    );
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${'is_required'.tr}';
    }
    return null;
  }

  Widget _buildSubmitButton() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Obx(() {
          return Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: controller.isLoading.value ? 0 : 2,
                shadowColor: colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: controller.isLoading.value
                  ? null
                  : () => _validateAndSubmit(),
              child: controller.isLoading.value
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      'connect_account'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        });
      },
    );
  }

  void _validateAndSubmit() {
    if (controller.formKey.currentState?.validate() ?? false) {
      controller.generateAccessToken();
    }
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
                'get_code_oauth'.tr,
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
