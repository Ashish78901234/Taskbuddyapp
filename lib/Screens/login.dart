import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Forgot_Password.dart';
import 'package:flutter_application_1/Screens/Home.dart';
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
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);

      DocumentSnapshot snapshot = await userDoc.get();

      if (!snapshot.exists) {
        await userDoc.set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'user',
        });
      }

      SnackbarHelper.showSuccess(context, AppConstants.loginSuccess);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaskHomePage()),
      );
    } on FirebaseAuthException {
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
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    AppConstants.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController,
                    obscureText: false,
                    hintText: AppConstants.EnterEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.emptyEmailError;
                      } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                        return AppConstants.invalidEmailError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: AppConstants.EnterPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.emptyPasswordError;
                      } else if (value.length < 8) {
                        return AppConstants.shortPasswordError;
                      } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%#*?&])[A-Za-z\d@$!#%*?&]{8,}$')
                          .hasMatch(value)) {
                        return 'Password must be at least 8 characters,\ninclude uppercase, lowercase, number, and special character';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextButton(
                        text: AppConstants.ForgotButton,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    buttonText: AppConstants.LoginButton,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    text: '',
                  ),
                  CustomTextButton(
                    text: AppConstants.DonotButton,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
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
