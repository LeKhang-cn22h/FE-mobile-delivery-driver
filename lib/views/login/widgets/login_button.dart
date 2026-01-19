import 'package:flutter/material.dart';
import 'package:test_f/core/theme/button_styles.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style:AppButtonStyles.roundedButtonBold, onPressed: onPressed, child: Text("Login"));
  }
}
