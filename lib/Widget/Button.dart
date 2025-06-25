import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/App_constant.dart';


class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 4,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColors.buttonText,
          ),
        ),
      ),
    );
  }
}


class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final double fontSize;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? AppColors.link,
          fontSize: fontSize,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
