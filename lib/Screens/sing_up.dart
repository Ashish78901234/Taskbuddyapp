// ignore_for_file: unused_catch_clause

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

  //  Password match check
  if (password != confirm) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppConstants.donotmatchPasswordError)),
    );
    return;
  }

  //  Show loading
  setState(() {
    isLoading = true;
  });

  try {
    //  Firebase pe user create karo
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
SnackbarHelper.showSuccess(context, AppConstants.SignupSuccess);

    //  Login screen Back
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
  SnackbarHelper.showError(context, AppConstants.SignupFailed );
    }
  finally {
    //  Hide loading
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.Signuptitle)),
      body: Form(key: _formKey,
        child: 
       Padding(
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
}, obscureText: true,

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
      }else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
     return 'Password must be at least 8 characters,\ninclude uppercase, lowercase, number, and special character';
  }
                      return null;
                    }, obscureText: true,
                ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: AppConstants.EnterConfirmPassword,
                  controller: confirmController,
                  isPassword: true,
                  validator: (value){
                        if(value == null || value.isEmpty){
                          return AppConstants.emptyconfirmPasswordError;
                        }
                        return null;
                      }, obscureText: true,
                ),
              const SizedBox(height: 20),
              isLoading
              ? const
              CircularProgressIndicator():
               SizedBox(height: 20),
               CustomButton(
  buttonText: AppConstants.SignupButton,
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      signUpUser();
    }
  }, text: AppConstants.Signuptext,
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
    ));
  }
}
