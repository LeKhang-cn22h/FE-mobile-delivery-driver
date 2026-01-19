import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/route_paths.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({super.key});

  int _indexFromLocation(String location) {
    if (location.startsWith(RoutePaths.orders)) return 1;
    if (location.startsWith(RoutePaths.map)) return 2;
    if (location.startsWith(RoutePaths.history)) return 3;
    if (location.startsWith(RoutePaths.notifications)) return 4;
    if (location.startsWith(RoutePaths.profile)) return 5;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: _indexFromLocation(location),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(RoutePaths.home);
            break;
          case 1:
            context.go(RoutePaths.orders);
            break;
          case 2:
            context.go(RoutePaths.map);
            break;
          case 3:
            context.go(RoutePaths.history);
            break;
          case 4:
            context.go(RoutePaths.notifications);
            break;
          case 5:
            context.go(RoutePaths.profile);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
