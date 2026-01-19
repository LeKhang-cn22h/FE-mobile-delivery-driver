import 'package:flutter/material.dart';
import 'package:test_f/views/login/widgets/email_field.dart';
import 'package:test_f/views/login/widgets/password_field.dart';
class LoginForm extends StatelessWidget {
  final TextEditingController Econtroller;
  final TextEditingController Pcontroller;
  final bool isVisible;
  final VoidCallback onPressed;

  const LoginForm({super.key, required this.Econtroller, required this.Pcontroller, required this.onPressed, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EmailField(controller: Econtroller),
          SizedBox(height: 16),
          PasswordField(controller: Pcontroller, isVisible: isVisible, onPressed: onPressed),
        ],
      ),
    );
  }
}
