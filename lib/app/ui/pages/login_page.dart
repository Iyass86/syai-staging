import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/message_display_container.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: MessageDisplayContainer(
        child: Container(
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
                  child: Card(
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
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'welcome_to_oauth_chat'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'sign_in_subtitle'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.7),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            _buildLoginForm(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          TextFormField(
            controller: controller.emailController,
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'email'.tr,
              hintText: 'Enter your email address',
              prefixIcon:
                  Icon(Icons.email_outlined, color: colorScheme.primary),
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
          ),
          const SizedBox(height: 24),
          // Password Field
          Obx(() => TextFormField(
                controller: controller.passwordController,
                validator: controller.validatePassword,
                obscureText: !controller.isPasswordVisible.value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.loginWithEmail(),
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  hintText: 'Enter your password',
                  prefixIcon:
                      Icon(Icons.lock_outlined, color: colorScheme.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: controller.togglePasswordVisibility,
                    tooltip: controller.isPasswordVisible.value
                        ? 'Hide password'
                        : 'Show password',
                  ),
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
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
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
              )),
          const SizedBox(height: 32),
          // Primary Login Button
          Obx(() {
            final authController = Get.find<AuthController>();
            return Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: authController.isLoading.value ? 0 : 2,
                  shadowColor: colorScheme.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                ),
                onPressed: authController.isLoading.value
                    ? null
                    : controller.loginWithEmail,
                child: authController.isLoading.value
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'login_with_email'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            );
          }),
          const SizedBox(height: 16),
          // Secondary Create Account Button
          Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.register),
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
              child: Text(
                'create_account'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Elegant Divider
          Container(
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
          ),
          const SizedBox(height: 24),
          // Guest Login Button
          Obx(() {
            final authController = Get.find<AuthController>();
            return Container(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: authController.isLoading.value
                    ? null
                    : controller.loginAsGuest,
                icon: authController.isLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      )
                    : Icon(
                        Icons.person_outline_rounded,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                label: Text(
                  'continue_as_guest'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: colorScheme.outline.withOpacity(0.4),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: colorScheme.surface.withOpacity(0.5),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          // Guest Mode Notice
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'guest_mode_notice'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                          height: 1.4,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
