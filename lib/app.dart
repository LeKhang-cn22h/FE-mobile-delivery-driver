import 'package:flutter/material.dart';
import 'package:test_f/routes/app_router.dart';

import 'core/theme/app_theme.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Route Planner',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}