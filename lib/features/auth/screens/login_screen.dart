import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/controller.dart';
import 'package:whatsapp/features/auth/screens/sign_up.dart';
import 'package:whatsapp/widgets/auth_field.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your Email and Password"),
        backgroundColor: tabColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthField(
                  controller: email,
                  hintText: "email",
                ),
                const SizedBox(height: 20),
                AuthField(
                  controller: password,
                  hintText: "password",
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Login",
                  onPressed: () {
                    ref.read(authControllerProvider).signIn(
                          email: email.text.trim(),
                          password: password.text.trim(),
                          context: context,
                        );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                          text: " Sign up",
                          style: TextStyle(
                            fontSize: 16,
                            color: tabColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, SignUp.routeName);
                            }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
