import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Screens/login.dart';
import 'package:flutter_application_1/Utils/App_constant.dart';
import 'package:flutter_application_1/Utils/SnackBar.dart';
import 'package:flutter_application_1/Widget/Button.dart';
import 'package:flutter_application_1/Widget/Text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void signUpUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirm = confirmController.text.trim();

    if (password != confirm) {
      SnackbarHelper.showError(context, AppConstants.donotmatchPasswordError);
      return;
    }

    setState(() => isLoading = true);

    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Store user info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user',
      });

      SnackbarHelper.showSuccess(context, AppConstants.SignupSuccess);
      Navigator.pop(context); // Go back to login screen
    } on FirebaseAuthException catch (e) {
      SnackbarHelper.showError(context, AppConstants.SignupFailed);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.Signuptitle)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: AppConstants.EnterEmail,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.emptyEmailError;
                    }
                    return null;
                  },
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: AppConstants.EnterPassword,
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.emptyPasswordError;
                    } else if (value.length < 8) {
                      return AppConstants.shortPasswordError;
                    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                        .hasMatch(value)) {
                      return 'Password must include uppercase,\nlowercase, number, and special character';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: AppConstants.EnterConfirmPassword,
                  controller: confirmController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.emptyconfirmPasswordError;
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        buttonText: AppConstants.SignupButton,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                        text: AppConstants.Signuptext,
                      ),
                CustomTextButton(
                  text: AppConstants.IHaveButton,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
