import 'package:flutter/material.dart';

class LoginSocialHandler {
  final BuildContext context;

  LoginSocialHandler(this.context);

  Future<void> loginWithGoogle() async {
    _showComingSoon('Google');
  }

  Future<void> loginWithFacebook() async {
    _showComingSoon('Facebook');
  }

  Future<void> loginWithApple() async {
    _showComingSoon('Apple');
  }

  void _showComingSoon(String provider) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng nhập bằng $provider - Coming soon'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}