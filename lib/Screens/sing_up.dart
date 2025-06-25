import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/login.dart';
import 'package:flutter_application_1/Widget/Button.dart';
import 'package:flutter_application_1/Widget/Text_field.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                controller: emailController,
                hintText: "Name",
               validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'enter your Name';
               }
               return null;
             },
                    ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
               validator: (value) {
               if (value == null || value.isEmpty) {
                 return 'enter your email';
               }
               return null;
             },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
                 validator: (value) {
               if (value == null || value.length < 8) {
                 return 'password must be 8 characters';
               }
               return null;
             },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: confirmPasswordController,
                hintText: "Password",
                obscureText: true,
               validator: (value) {
                if (value == null || value != passwordController.text) {
                  return 'password do not match';
                }
                return null;
                
              },
              ),
              SizedBox(height: 20,),
             CustomButton(
                   buttonText: "Sign Up",
                 onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Sign_up successful");
                    Navigator.push(
          context,
                 MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  },
                     backgroundColor: Colors.white,
                      textColor: Colors.blue,
                  ),
                  CustomTextButton(
                    text: "Already have an account? Login",
                       onPressed: () {
                        Navigator.pop(context); 
                         },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
