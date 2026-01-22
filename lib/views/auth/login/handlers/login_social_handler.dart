import 'package:flutter/material.dart';

/// LoginSocialHandler - Xử lý đăng nhập bằng mạng xã hội
class LoginSocialHandler {
  final BuildContext context;

  LoginSocialHandler(this.context);

  /// Đăng nhập bằng Google
  Future<bool> loginWithGoogle() async {
    // TODO: Implement Google Sign In
    _showComingSoon('Google');
    return false;
  }

  /// Đăng nhập bằng Facebook
  Future<bool> loginWithFacebook() async {
    // TODO: Implement Facebook Sign In
    _showComingSoon('Facebook');
    return false;
  }

  /// Đăng nhập bằng Apple
  Future<bool> loginWithApple() async {
    // TODO: Implement Apple Sign In
    _showComingSoon('Apple');
    return false;
  }

  void _showComingSoon(String provider) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng nhập bằng $provider - Coming soon'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}