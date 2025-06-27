import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/sing_up.dart';
import 'package:flutter_application_1/Utils/App_constant.dart';
import 'package:flutter_application_1/Utils/SnackBar.dart';
import 'package:flutter_application_1/Widget/Button.dart';
import 'package:flutter_application_1/Widget/Text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

SnackbarHelper.showSuccess(context, AppConstants.loginSuccess);


// ignore: unused_catch_clause
} on FirebaseAuthException catch (e) {
  SnackbarHelper.showError(context, AppConstants.loginFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // form key for validation
              child: Column(
                children: [
                  // FlutterLogo(size: 80),
                  SizedBox(height: 20),
                  Text(
                    AppConstants.title,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Email field with validation
                  CustomTextField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                       return AppConstants.emptyEmailError;
                      } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                       return AppConstants.invalidEmailError;
                      }
                      return null;
                    }, obscureText: true, hintText: AppConstants.EnterEmail,
                  ),
                  SizedBox(height: 10),

                  // Password field with validation
                  CustomTextField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                       return AppConstants.emptyPasswordError;
                      } else if (value.length < 8) {
                       return AppConstants.shortPasswordError;
      }else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
     return 'Password must be at least 8 characters,\ninclude uppercase, lowercase, number, and special character';
  }
                      return null;
                    }, hintText: AppConstants.EnterPassword,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                  children:[ CustomTextButton(
                    text: AppConstants.ForgotButton,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SignupScreen()),
                      // );
                    },
                  )]),
                  SizedBox(height: 20),

                  // Login Button
                  CustomButton(
                    buttonText: AppConstants.LoginButton,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    }, text: '',
                  ),

                  // Sign Up Link
                  CustomTextButton(
                    text: AppConstants.DonotButton,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
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
