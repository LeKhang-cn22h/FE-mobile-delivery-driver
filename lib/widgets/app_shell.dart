import 'package:flutter/material.dart';
import 'app_header.dart';
import 'app_bottom_bar.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String title;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: title),
      body: child,
      bottomNavigationBar: const AppBottomBar(),
    );
  }
}
