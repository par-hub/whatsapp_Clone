import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/controller.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/widgets/auth_field.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/custom_button.dart';

class SignUp extends ConsumerStatefulWidget {
  // ✅ change here
  static const routeName = '/sign-up';
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState(); // ✅ change here
}

class _SignUpState extends ConsumerState<SignUp> {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpass = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

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
                const SizedBox(height: 20),
                AuthField(
                  controller: confirmpass,
                  hintText: "Confirm Passsword",
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: "Sign Up",
                  onPressed: () {
                    ref.read(authControllerProvider).signUp(
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
                    text: "Already have an account?",
                    style: TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                          text: "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: tabColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
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
