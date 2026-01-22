import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_f/routes/route_paths.dart';
import 'package:test_f/views/profile/widgets/profile_header.dart';
import 'package:test_f/views/profile/widgets/profile_menu_item.dart';
import '../../viewmodels/profile_viewmodel.dart';


/// ProfilePage - Trang cá nhân
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load user data khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          // === LOADING STATE ===
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // === ERROR STATE ===
          if (viewModel.hasError && !viewModel.hasUser) {
            return _buildErrorView(viewModel);
          }

          // === LOADED STATE ===
          if (viewModel.hasUser) {
            return _buildProfileContent(viewModel);
          }

          // === INITIAL STATE ===
          return const Center(
            child: Text('Không có dữ liệu'),
          );
        },
      ),
    );
  }

  /// Widget hiển thị lỗi
  Widget _buildErrorView(ProfileViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage ?? 'Đã xảy ra lỗi',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.loadCurrentUser(),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị nội dung profile
  Widget _buildProfileContent(ProfileViewModel viewModel) {
    final user = viewModel.user!;

    return RefreshIndicator(
      onRefresh: () => viewModel.loadCurrentUser(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // === HEADER: Avatar + Tên + Email ===
            ProfileHeader(user: user),

            const SizedBox(height: 24),

            // === MENU ITEMS ===
            _buildMenuSection(viewModel),
          ],
        ),
      ),
    );
  }

  /// Widget menu section
  Widget _buildMenuSection(ProfileViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chỉnh sửa thông tin
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Chỉnh sửa thông tin',
            onTap: () => _navigateToEditProfile(),
          ),

          const Divider(height: 1),

          // Đổi mật khẩu
          ProfileMenuItem(
            icon: Icons.lock_outline,
            title: 'Đổi mật khẩu',
            onTap: () => _navigateToChangePassword(),
          ),

          const Divider(height: 1),

          // Đăng xuất
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Đăng xuất',
            iconColor: Colors.red,
            titleColor: Colors.red,
            onTap: () => _showLogoutDialog(viewModel),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // NAVIGATION METHODS
  // ==========================================

  void _navigateToEditProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _navigateToChangePassword() {
    Navigator.pushNamed(context, '/change-password');
  }

  // ==========================================
  // LOGOUT DIALOG
  // ==========================================

  void _showLogoutDialog(ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Đóng dialog
              await viewModel.logout();
              if (mounted) {
                // Quay về màn hình login
                context.go(RoutePaths.login);
              }
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}