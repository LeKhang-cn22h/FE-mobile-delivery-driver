import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/auth_viewmodel.dart';
import 'handlers/login_form_handler.dart';
import 'handlers/login_navigation_handler.dart';
import 'handlers/login_social_handler.dart';
import 'widgets/auth_link_text.dart';
import 'widgets/error_banner.dart';
import 'widgets/login_button.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';
import 'widgets/social_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form key và controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Handlers
  late LoginFormHandler _formHandler;
  late LoginNavigationHandler _navHandler;
  late LoginSocialHandler _socialHandler;

  @override
  void initState() {
    super.initState();
    // Clear error khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().clearError();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Khởi tạo handlers
    _formHandler = LoginFormHandler(
      context: context,
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
    );
    _navHandler = LoginNavigationHandler(context);
    _socialHandler = LoginSocialHandler(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Xử lý khi nhấn nút đăng nhập
  Future<void> _onLoginPressed() async {
    final success = await _formHandler.submit();

    if (success && mounted) {
      _navHandler.showSuccess('Đăng nhập thành công!');
      _navHandler.goToHome();
    }
  }

  /// Xử lý đăng nhập Google
  Future<void> _onGooglePressed() async {
    await _socialHandler.loginWithGoogle();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // === HEADER ===
                    const LoginHeader(),

                    const SizedBox(height: 24),

                    // === ERROR BANNER ===
                    _buildErrorBanner(),

                    // === LOGIN FORM ===
                    _buildLoginForm(),

                    const SizedBox(height: 8),

                    // === QUÊN MẬT KHẨU ===
                    _buildForgotPassword(),

                    const SizedBox(height: 24),

                    // === LOGIN BUTTON ===
                    _buildLoginButton(),

                    const SizedBox(height: 24),

                    // === SOCIAL BUTTONS ===
                    SocialButtons(onGGPressed: _onGooglePressed),

                    const SizedBox(height: 16),

                    // === REGISTER LINK ===
                    AuthLinkText(
                      normalText: "Chưa có tài khoản?",
                      linkText: "Đăng ký",
                      onPressed: () => _navHandler.goToRegister(),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
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

        return ErrorBanner(
          message: viewModel.errorMessage ?? '',
          onDismiss: () => viewModel.clearError(),
        );
      },
    );
  }

  /// Login Form - lắng nghe password visibility từ ViewModel
  Widget _buildLoginForm() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return LoginForm(
          emailController: _emailController,
          passwordController: _passwordController,
          isPasswordVisible: viewModel.isPasswordVisible,
          onTogglePassword: () => viewModel.togglePasswordVisibility(),
          emailValidator: _formHandler.validateEmail,
          passwordValidator: _formHandler.validatePassword,
        );
      },
    );
  }

  /// Quên mật khẩu link
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _navHandler.goToForgotPassword(),
        child: const Text(
          'Quên mật khẩu?',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  /// Login Button - lắng nghe loading từ ViewModel
  Widget _buildLoginButton() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return LoginButton(
          onPressed: viewModel.isLoading ? null : _onLoginPressed,
          text: "Đăng nhập",
          isLoading: viewModel.isLoading,
        );
      },
    );
  }
}