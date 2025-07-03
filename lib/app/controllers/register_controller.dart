import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final grantType = 'authorization_code'.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  final _authController = Get.find<AuthController>();

  get isPasswordObscured => _isPasswordObscured.value;
  final _isPasswordObscured = true.obs;

  registerUser() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    _authController.register(fullNameController.text.trim(),
        emailController.text.trim(), passwordController.text.trim());
  }

  void togglePasswordVisibility() {
    _isPasswordObscured.value = !_isPasswordObscured.value;
  }
}
