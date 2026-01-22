import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/auth_viewmodel.dart';

/// LoginFormHandler - Xử lý form logic cho LoginPage
class LoginFormHandler {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginFormHandler({
    required this.context,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  /// Lấy ViewModel từ context
  AuthViewModel get _viewModel => context.read<AuthViewModel>();

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  /// Submit form - gọi ViewModel login
  Future<bool> submit() async {
    // Validate form trước
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Ẩn keyboard
    FocusScope.of(context).unfocus();

    // Gọi ViewModel
    return await _viewModel.login(
      emailController.text.trim(),
      passwordController.text,
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _viewModel.togglePasswordVisibility();
  }

  /// Clear error message
  void clearError() {
    _viewModel.clearError();
  }

  /// Dispose controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}