import 'package:go_router/go_router.dart';
import 'package:test_f/routes/shell_route.dart';
import '../views/auth/login/login_page.dart';
import '../views/auth/register/Register_page.dart';

import 'route_paths.dart';
import 'route_names.dart';

final router = GoRouter(
  initialLocation: RoutePaths.login,
  routes: [
    GoRoute(path:RoutePaths.login,
      name: RouteNames.login,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginPage(),
      ),
    ),
    GoRoute(path: RoutePaths.register,
    name: RouteNames.register,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RegisterPage(),
      ),

    ),
    shellRoutes,
  ],
);