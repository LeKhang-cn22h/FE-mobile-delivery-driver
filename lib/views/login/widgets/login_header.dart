import 'package:flutter/material.dart';

import '../../../core/theme/AppImages.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Image.asset(AppImages.logo),
    );
  }
}
