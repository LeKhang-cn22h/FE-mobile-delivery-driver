import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isVisible;
  final VoidCallback onPressed;
  const PasswordField({super.key, required this.controller,required this.isVisible, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isVisible,
      decoration: InputDecoration(
        labelText: "Password",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: IconButton(onPressed: onPressed, icon: Icon(isVisible?Icons.visibility:Icons.visibility_off))

      ),
    );
  }
}
