import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/route_viewmodel.dart';
import 'viewmodels/navigation_viewmodel.dart';
import 'views/map/map_screen.dart';

import 'orders/injection/order_injection.dart';
import 'orders/presentation/views/order_list_screen.dart';
import 'notifications/domain/usecases/init_fcm_usecase.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize FCM
  await InitFcmUsecase().call();

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
        // Thêm orders
        ...OrderInjection.getProviders(),
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
      // Thêm router cho orders
      routes: {
        '/orders': (_) => const OrderListScreen(),
      },
    );
  }
}