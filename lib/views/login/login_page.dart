import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_f/routes/route_names.dart';
import 'package:test_f/views/login/widgets/auth_link_text.dart';
import 'package:test_f/views/login/widgets/glass_bottom_overlay.dart';
import 'package:test_f/views/login/widgets/login_button.dart';
import 'package:test_f/views/login/widgets/login_form.dart';
import 'package:test_f/views/login/widgets/login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passController=TextEditingController();

  bool _passVisibility=false;
  void _togglePassVisibility(){
    setState(() {
      _passVisibility=!_passVisibility;
    });
  }
  void _onLoginPressed(){
    final email=_emailController.text;
    final pass=_passController.text;
    print("Email: $email, Password: $pass");
    context.go('/home');
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
        children:[
          Positioned.fill(

          top: 0,
          left: 0,
          right: 0,

          child:
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.orange,
                  ]
              )
            ),
            child: SafeArea(
                 child:
                    Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginHeader(),
              LoginForm(Econtroller: _emailController, Pcontroller: _passController,
                  onPressed: _togglePassVisibility, isVisible: _passVisibility),
              LoginButton(onPressed: _onLoginPressed),
              AuthLinkText(normalText:"Chưa có tài khoản?" ,onPressed:()=> context.goNamed(RouteNames.register) ,linkText: "Register",)
            ],
                    )
                    ),
          ),
          )
        ],
      ),

    );
  }
}
