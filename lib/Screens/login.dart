import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
             decoration: InputDecoration(labelText: 'Enter Email',border: OutlineInputBorder()),
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
           SizedBox(height: 80),
           ElevatedButton(
             onPressed: () {
               if(formKey.currentState!.validate()){
                 print("login successful");
               }
             },
             child: Text('Login'),
             
             style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity,48),shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
           ),
           TextButton(
             onPressed: () {
               Navigator.pushNamed(context, '/signup');
             },
             child: Text("Don't have an account? Sign up"),
           ),
         ],
       ),
            )]) )));
  }
}