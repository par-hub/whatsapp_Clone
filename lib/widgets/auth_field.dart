import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final hintText;
  final bool obscureText;
  const AuthField(
      {super.key,
      required this.controller,
      this.hintText,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: tabColor, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey, width: 3),
        ),
        contentPadding: EdgeInsets.all(22),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}
