import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_f/views/auth/login/widgets/login_button.dart';
import 'package:test_f/views/auth/login/widgets/login_header.dart';
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

  // State
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Gọi API register
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/home');
    }
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
                  // Header
                  LoginHeader(),

                  // NAME FIELD
                  SimpleField(
                    controller: _nameController,
                    type: FieldType.name,
                  ),

                  const SizedBox(height: 16),

                  // EMAIL FIELD
                  SimpleField(
                    controller: _emailController,
                    type: FieldType.email,
                  ),

                  const SizedBox(height: 16),

                  // PHONE FIELD (Optional)
                  SimpleField(
                    controller: _phoneController,
                    type: FieldType.phone,
                    label: 'Số điện thoại (không bắt buộc)',
                  ),

                  const SizedBox(height: 16),

                  // PASSWORD FIELD
                  SimpleField(
                    controller: _passwordController,
                    type: FieldType.password,
                    isPasswordVisible: _isPasswordVisible,
                    onTogglePassword: _togglePasswordVisibility,
                  ),

                  const SizedBox(height: 16),

                  // CONFIRM PASSWORD FIELD
                  SimpleField(
                    controller: _confirmPasswordController,
                    type: FieldType.confirmPassword,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onTogglePassword: _toggleConfirmPasswordVisibility,
                    passwordController: _passwordController,
                  ),

                  const SizedBox(height: 32),

                  // REGISTER BUTTON - ĐÃ SỬA
                  LoginButton(
                    onPressed: _onRegisterPressed,
                    text: 'Đăng ký',
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 6),

                  // LOGIN LINK
                  AuthLinkText(
                    onPressed: () => context.go('/login'),
                    normalText: 'Đã có tài khoản?',
                    linkText: 'Đăng nhập',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}