import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/history/history_page.dart';
import '../views/home/home_page.dart';
import '../views/map/map_screen.dart';
import '../views/notification/notification_page.dart';
import '../views/order/OrderDetail/Order_Detail_Page.dart';
import '../views/order/order_page.dart';
import '../views/profile/profile_page.dart';
import '../widgets/app_shell.dart';
import 'route_paths.dart';
import 'route_names.dart';

/// SHELL ROUTES - Các routes có AppBar + BottomNavigationBar

final shellRoutes = ShellRoute(
  builder: (context, state, child) {
    final title = switch (state.matchedLocation) {
      RoutePaths.orders => 'Orders',
      RoutePaths.profile => 'Profile',
      RoutePaths.map => 'Map',
      RoutePaths.history => 'History',
      RoutePaths.notifications => 'Notifications',
      _ => 'Home',
    };
    return AppShell(
      title: title,
      child: child,
    );
  },
  routes: [
    // Home
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: HomePage(),
      ),
    ),

    // Orders + nested detail
    GoRoute(
      path: RoutePaths.orders,
      name: RouteNames.orders,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: OrderPage(),
      ),
      routes: [
        GoRoute(
          path: 'detail/:orderId',
          name: RouteNames.orderDetail,
          builder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return OrderDetailPage(orderId: orderId);
          },
        ),
      ],
    ),

    // Map
    GoRoute(
      path: RoutePaths.map,
      name: RouteNames.map,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MapScreen(),
      ),
    ),

    // History
    GoRoute(
      path: RoutePaths.history,
      name: RouteNames.history,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: HistoryPage(),
      ),
    ),

    // Notifications
    GoRoute(
      path: RoutePaths.notifications,
      name: RouteNames.notifications,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: NotificationPage(),
      ),
    ),

    // Profile
    GoRoute(
      path: RoutePaths.profile,
      name: RouteNames.profile,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: ProfilePage(),
      ),
    ),
  ],
);