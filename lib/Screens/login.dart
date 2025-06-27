import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/sing_up.dart';
import 'package:flutter_application_1/Utils/Theme.dart';
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful ✅",),backgroundColor: AppColors.success,
        ),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.message}"),
        backgroundColor: AppColors.error,
        ),
      );
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
                    "TaskBuddy",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Email field with validation
                  CustomTextField(
                    hintText: "Enter Email",
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    }, obscureText: true,
                  ),
                  SizedBox(height: 10),

                  // Password field with validation
                  CustomTextField(
                    hintText: "Enter Password",
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                       else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Login Button
                  CustomButton(
                    buttonText: "Login",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    }, text: '',
                  ),

                  // Sign Up Link
                  CustomTextButton(
                    text: "Don't have an account? Sign Up",
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
