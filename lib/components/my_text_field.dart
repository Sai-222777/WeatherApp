import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({super.key, required this.controller, required this.hintText, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(37, 145, 188, 1)),
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(80, 239, 133, 1)),
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        fillColor: Colors.amber[100],
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[700])
      ),
    );
  }
}