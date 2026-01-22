import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:test_f/viewmodels/auth_viewmodel.dart';
import 'package:test_f/viewmodels/profile_viewmodel.dart';

import 'firebase_options.dart';
import 'app.dart';
import 'viewmodels/location_viewmodel.dart';
import 'viewmodels/route_viewmodel.dart';
import 'viewmodels/navigation_viewmodel.dart';
import 'orders/injection/order_injection.dart';
import 'notifications/domain/usecases/init_fcm_usecase.dart';
import 'notifications/data/datasources/fcm_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print(' Firebase initialized');

    final fcmDataSource = FCMDataSource();
    await InitFcmUsecase(fcmDataSource).call();
  } catch (e) {
    print(' Initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationViewModel()..initLocation()),
        ChangeNotifierProvider(create: (_) => RouteViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),

        ...OrderInjection.getProviders(),
      ],
      child: const MyApp(),
    ),
  );
}