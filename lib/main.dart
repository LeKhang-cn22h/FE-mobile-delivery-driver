import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/route_viewmodel.dart';
import 'viewmodels/navigation_viewmodel.dart';
import 'views/map/map_screen.dart';
import 'orders/injection/order_injection.dart';
import 'orders/presentation/views/order_list_screen.dart';
import 'notifications/domain/usecases/init_fcm_usecase.dart';
import 'notifications/data/datasources/fcm_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized');

    // Initialize FCM
    final fcmDataSource = FCMDataSource();
    await InitFcmUsecase(fcmDataSource).call();
  } catch (e) {
    print('❌ Initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationViewModel()..initLocation(),
        ),
        ChangeNotifierProvider(
          create: (_) => RouteViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationViewModel(),
        ),
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
      routes: {
        '/orders': (_) => const OrderListScreen(),
      },
    );
  }
}
