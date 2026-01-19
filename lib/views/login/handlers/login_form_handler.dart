import 'package:flutter/material.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class LoginFormHandler {
  final AuthViewModel viewModel;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginFormHandler({
    required this.viewModel,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    return await viewModel.login(
      emailController.text.trim(),
      passwordController.text,
    );
  }

  void togglePassword() {
    viewModel.togglePasswordVisibility();
  }

  void clearError() {
    viewModel.clearError();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}