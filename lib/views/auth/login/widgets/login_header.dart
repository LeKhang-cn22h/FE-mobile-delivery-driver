import 'package:flutter/material.dart';

import '../../../../core/theme/AppImages.dart';
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CircleAvatar(
        radius: 150,
        backgroundImage: AssetImage(AppImages.logo),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
