import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:test_f/routes/route_paths.dart';
import 'package:test_f/viewmodels/auth_viewmodel.dart';
import 'package:test_f/views/auth/login/widgets/login_button.dart';
import 'package:test_f/views/auth/login/widgets/login_header.dart';
import 'package:test_f/views/auth/login/widgets/error_banner.dart';
import '../login/widgets/auth_link_text.dart';
import 'widgets/simple_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear error khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().clearError();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Xử lý đăng ký
  /// Xử lý đăng ký
  Future<void> _onRegisterPressed() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ẩn keyboard
    FocusScope.of(context).unfocus();

    // Gọi ViewModel
    final viewModel = context.read<AuthViewModel>();
    final success = await viewModel.register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    // Xử lý kết quả
    if (success && mounted) {
      _showSuccessAndNavigate();
    }
  }

  /// Hiển thị thông báo thành công và chuyển về trang LOGIN
  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.orange],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // === HEADER ===
                  const LoginHeader(),

                  const SizedBox(height: 24),

                  // === ERROR BANNER ===
                  _buildErrorBanner(),

                  // === NAME FIELD ===
                  SimpleField(
                    controller: _nameController,
                    type: FieldType.name,
                  ),

                  const SizedBox(height: 16),

                  // === EMAIL FIELD ===
                  SimpleField(
                    controller: _emailController,
                    type: FieldType.email,
                  ),

                  const SizedBox(height: 16),

                  // === PHONE FIELD (Optional) ===
                  SimpleField(
                    controller: _phoneController,
                    type: FieldType.phone,
                    label: 'Số điện thoại (không bắt buộc)',
                  ),

                  const SizedBox(height: 16),

                  // === PASSWORD FIELD ===
                  _buildPasswordField(),

                  const SizedBox(height: 16),

                  // === CONFIRM PASSWORD FIELD ===
                  _buildConfirmPasswordField(),

                  const SizedBox(height: 32),

                  // === REGISTER BUTTON ===
                  _buildRegisterButton(),

                  const SizedBox(height: 16),

                  // === LOGIN LINK ===
                  AuthLinkText(
                    onPressed: () => context.go('/login'),
                    normalText: 'Đã có tài khoản?',
                    linkText: 'Đăng nhập',
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Error Banner - lắng nghe từ ViewModel
  Widget _buildErrorBanner() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.hasError) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ErrorBanner(
            message: viewModel.errorMessage ?? '',
            onDismiss: () => viewModel.clearError(),
          ),
        );
      },
    );
  }

  /// Password Field - lắng nghe visibility từ ViewModel
  Widget _buildPasswordField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return SimpleField(
          controller: _passwordController,
          type: FieldType.password,
          isPasswordVisible: viewModel.isPasswordVisible,
          onTogglePassword: () => viewModel.togglePasswordVisibility(),
        );
      },
    );
  }

  /// Confirm Password Field - lắng nghe visibility từ ViewModel
  Widget _buildConfirmPasswordField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return SimpleField(
          controller: _confirmPasswordController,
          type: FieldType.confirmPassword,
          isPasswordVisible: viewModel.isConfirmPasswordVisible,
          onTogglePassword: () => viewModel.toggleConfirmPasswordVisibility(),
          passwordController: _passwordController,
        );
      },
    );
  }

  /// Register Button - lắng nghe loading từ ViewModel
  Widget _buildRegisterButton() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return LoginButton(
          onPressed: viewModel.isLoading ? null : _onRegisterPressed,
          text: 'Đăng ký',
          isLoading: viewModel.isLoading,
        );
      },
    );
  }
}