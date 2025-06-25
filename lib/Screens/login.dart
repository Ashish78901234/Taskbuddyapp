import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/sing_up.dart';
import 'package:flutter_application_1/Widget/Button.dart';
import 'package:flutter_application_1/Widget/Text_field.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              const SizedBox(height: 20),
              CustomButton(
                buttonText: "Login",
                  onPressed: () {
                   if (_formKey.currentState!.validate()) {
                   }
                   },
                   ),

             CustomTextButton(
              text: "Don't have an account? Sign Up",
                onPressed: () {
                Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => SignUpPage()),
                   );
                },
             ),
            ],
          ),
        ),
      ),
    );
  }
}
