import 'package:go_router/go_router.dart';
import 'package:test_f/routes/shell_route.dart';
import 'package:test_f/core/storage/auth_storage.dart';
import '../views/auth/login/login_page.dart';
import '../views/auth/register/register_page.dart';

import 'route_paths.dart';
import 'route_names.dart';

final router = GoRouter(
  initialLocation: RoutePaths.home, // Đổi thành home, redirect sẽ xử lý

  // ===== REDIRECT LOGIC =====
  redirect: (context, state) async {
    final authStorage = AuthStorage();
    final isLoggedIn = await authStorage.isLoggedIn();

    // Các trang không cần đăng nhập
    final publicRoutes = [
      RoutePaths.login,
      RoutePaths.register,
      // Thêm các trang public khác nếu có
    ];

    final currentPath = state.matchedLocation;
    final isPublicRoute = publicRoutes.contains(currentPath);

    // CASE 1: Chưa đăng nhập + vào trang protected → về login
    if (!isLoggedIn && !isPublicRoute) {
      return RoutePaths.login;
    }

    // CASE 2: Đã đăng nhập + vào trang login/register → về home
    if (isLoggedIn && isPublicRoute) {
      return RoutePaths.home;
    }

    // CASE 3: Không cần redirect
    return null;
  },

  routes: [
    // === AUTH ROUTES (không có shell) ===
    GoRoute(
      path: RoutePaths.login,
      name: RouteNames.login,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginPage(),
      ),
    ),
    GoRoute(
      path: RoutePaths.register,
      name: RouteNames.register,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RegisterPage(),
      ),
    ),

    // === MAIN APP ROUTES (có shell) ===
    shellRoutes,
  ],
);
