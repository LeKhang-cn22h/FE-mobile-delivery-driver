import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// LoginNavigationHandler - Xử lý navigation cho LoginPage
class LoginNavigationHandler {
  final BuildContext context;

  LoginNavigationHandler(this.context);

  /// Navigate đến Home (dùng go_router)
  void goToHome() {
    if (!context.mounted) return;
    context.go('/home');
  }

  /// Navigate đến Register
  void goToRegister() {
    if (!context.mounted) return;
    context.push('/register');
  }

  /// Navigate đến Forgot Password
  void goToForgotPassword() {
    if (!context.mounted) return;
    context.push('/forgot-password');
  }

  /// Hiển thị thông báo
  void showMessage(String message, {bool isError = false}) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  /// Hiển thị success message
  void showSuccess(String message) {
    showMessage(message, isError: false);
  }

  /// Hiển thị error message
  void showError(String message) {
    showMessage(message, isError: true);
  }
}