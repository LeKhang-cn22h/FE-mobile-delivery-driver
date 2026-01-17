import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/route_viewmodel.dart';
import 'viewmodels/navigation_viewmodel.dart';
import 'views/screens/map_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // 1. Quản lý vị trí - Tự động chạy initLocation khi khởi tạo
        ChangeNotifierProvider(
          create: (_) => LocationViewModel()..initLocation(),
        ),
        // 2. Quản lý lộ trình và thuật toán OSRM
        ChangeNotifierProvider(
          create: (_) => RouteViewModel(),
        ),
        // 3. Quản lý logic đến điểm dừng và xác nhận
        ChangeNotifierProvider(
          create: (_) => NavigationViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Route Planner',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}