import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/login.dart';

class SignUpPage extends StatelessWidget {
    final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        child: Form(key: formKey,
        child:Column(
          children: [Padding(
       padding: EdgeInsets.all(20),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email',border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'enter your email';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password',border: OutlineInputBorder()),
               validator: (value) {
                if (value == null || value.length < 8) {
                  return 'password must be 8 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password',border: OutlineInputBorder()),
               validator: (value) {
                if (value == null || value != passwordController.text) {
                  return 'password do not match';
                }
                return null;
                
              },
            ),
            SizedBox(height: 80),
           ElevatedButton(
             onPressed: () {
               if(formKey.currentState!.validate()){
                 print("Sign_up successful");
                  Navigator.push(
          context,
                 MaterialPageRoute(builder: (context) => LoginPage()));
               }
             
             },
             child: Text('Sign_up'),
             style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity,48),shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            
           ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    ]))));
  }
}