import 'package:flutter/material.dart';

class AuthLinkText extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onPressed;
  const AuthLinkText({super.key, required this.normalText, required this.linkText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(normalText),
        TextButton(onPressed: onPressed, child: Text(linkText, style: TextStyle(color: Colors.blue),))
      ],
    );
  }
}
