import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_f/routes/route_names.dart';
import 'package:test_f/views/auth/login/widgets/auth_link_text.dart';
import 'package:test_f/views/auth/login/widgets/error_banner.dart';
import 'package:test_f/views/auth/login/widgets/login_button.dart';
import 'package:test_f/views/auth/login/widgets/login_form.dart';
import 'package:test_f/views/auth/login/widgets/login_header.dart';
import 'package:test_f/views/auth/login/widgets/social_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _passVisibility = false;
  String _errorMessage = "";
  bool _isLoading = false;  // THÊM

  void _togglePassVisibility() {
    setState(() {
      _passVisibility = !_passVisibility;
    });
  }

  void _clearError() {
    setState(() {
      _errorMessage = "";
    });
  }

  Future<void> _onLoginPressed() async {  // ĐỔI THÀNH ASYNC
    final email = _emailController.text.trim();
    final pass = _passController.text;

    // Validate
    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _errorMessage = "Vui lòng nhập đầy đủ thông tin";
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = "Email không hợp lệ";
      });
      return;
    }

    // Clear error và bắt đầu loading
    _clearError();
    setState(() => _isLoading = true);

    // TODO: Gọi API login
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      print("Email: $email, Password: $pass");
      context.go('/home');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.orange,
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(  // THÊM để tránh overflow
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      const LoginHeader(),

                      const SizedBox(height: 12),

                      ErrorBanner(
                        message: _errorMessage,
                        onDismiss: _clearError,
                      ),

                      LoginForm(
                        Econtroller: _emailController,
                        Pcontroller: _passController,
                        onPressed: _togglePassVisibility,
                        isVisible: _passVisibility,
                      ),

                      // THÊM isLoading
                      LoginButton(
                        onPressed: _onLoginPressed,
                        text: "Đăng nhập",
                        isLoading: _isLoading,
                      ),

                      const SizedBox(height: 12),

                      // SocialButtons(onGGPressed: _onGooglePressed),

                      AuthLinkText(
                        normalText: "Chưa có tài khoản?",
                        onPressed: () => context.goNamed(RouteNames.register),
                        linkText: "Đăng ký",
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}