import 'package:flutter/material.dart';

class LoginNavigationHandler {
  final BuildContext context;

  LoginNavigationHandler(this.context);

  void goToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void goToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  void goToForgotPassword() {
    showMessage('Quên mật khẩu - Coming soon');
  }

  void showMessage(String message, {bool isError = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}