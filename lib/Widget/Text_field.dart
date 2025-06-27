import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;



  const CustomTextField(
     {
    super.key,
    required this.controller,
    this.isPassword = false,
      required bool obscureText,
       this.validator, required this.hintText, 
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
            validator: validator,
      );
  }
}