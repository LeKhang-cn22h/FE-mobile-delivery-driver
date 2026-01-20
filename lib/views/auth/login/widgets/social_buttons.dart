import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  final VoidCallback onGGPressed;
  const SocialButtons({super.key, required this.onGGPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(onPressed: onGGPressed,
        icon: Icon(Icons.g_mobiledata),
        label: const Text("Đăng nhập GG"),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(6),
          side: BorderSide(color: Colors.black)
        ),
    );
  }
}
