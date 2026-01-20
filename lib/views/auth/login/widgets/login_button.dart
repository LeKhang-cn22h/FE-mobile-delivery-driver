import 'package:flutter/material.dart';
import 'package:test_f/core/theme/button_styles.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextButton(
        style: AppButtonStyles.roundedButtonBold,
        onPressed: isLoading ? null : onPressed, // Disable khi loading
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(text),
      ),
    );
  }
}