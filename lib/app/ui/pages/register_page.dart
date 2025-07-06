import 'package:flutter/material.dart';
import 'package:flutter_oauth_chat/app/controllers/auth_controller.dart';
import 'package:flutter_oauth_chat/app/controllers/register_controller.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

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
                  Icons.person_add_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Join us to start your chat experience',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _buildRegisterForm(),
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
              // Full Name Field
              _buildFormField(
                controller: controller.fullNameController,
                labelText: 'full_name'.tr,
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outlined,
                validator: (value) => _requiredValidator(value, 'full_name'.tr),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),

              // Email Field
              _buildFormField(
                controller: controller.emailController,
                labelText: 'email'.tr,
                hintText: 'Enter your email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => _requiredValidator(value, 'Email'),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),

              // Password Field
              Obx(
                () => _buildFormField(
                  controller: controller.passwordController,
                  labelText: 'password'.tr,
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: controller.isPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordObscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: controller.togglePasswordVisibility,
                    tooltip: controller.isPasswordObscured
                        ? 'Show password'
                        : 'Hide password',
                  ),
                  validator: (value) => _requiredValidator(value, 'Password'),
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(height: 24),

              // Confirm Password Field
              Obx(
                () => _buildFormField(
                  controller: controller.confirmPasswordController,
                  labelText: 'confirm_password'.tr,
                  hintText: 'Confirm your password',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: controller.isPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordObscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: controller.togglePasswordVisibility,
                    tooltip: controller.isPasswordObscured
                        ? 'Show password'
                        : 'Hide password',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Confirm Password is required';
                    }
                    if (value != controller.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
              const SizedBox(height: 16),

              // Login Link
              _buildLoginLink(),
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
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
    required ColorScheme colorScheme,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: colorScheme.primary),
        suffixIcon: suffixIcon,
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
      return '$fieldName is required';
    }
    return null;
  }

  Widget _buildSubmitButton() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Obx(() {
          final _authController = Get.find<AuthController>();
          return Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: _authController.isLoading.value ? 0 : 2,
                shadowColor: colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _authController.isLoading.value
                  ? null
                  : () => _validateAndSubmit(),
              child: _authController.isLoading.value
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      'create_account'.tr,
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
      controller.registerUser();
    }
  }

  Widget _buildLoginLink() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.login),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
