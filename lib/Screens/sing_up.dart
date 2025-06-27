import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Screens/login.dart';
import 'package:flutter_application_1/Utils/Theme.dart';
//import 'package:flutter_application_1/Utils/Theme.dart';
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
      const SnackBar(content: Text("Passwords do not match")),
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Signup Successful ✅"),
      backgroundColor: AppColors.success,
      ),
    );

    //  Login screen Back
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {

    //  Error message show
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signup failed: ${e.message}"),
      backgroundColor: AppColors.error,
      ),
    );
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
      appBar: AppBar(title: const Text("Sign Up")),
      body: Form(key: _formKey,
        child: 
       Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
             CustomTextField(
                  hintText: "Enter Email",
                  controller: emailController, 
                 validator: (value){
                        if(value == null || value.isEmpty){
                          return "please enter your Email";
                        }
                        return null;
                      }, obscureText: true,
                ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: "Enter Password",
               controller: passwordController,
               isPassword: true,
                validator: (value){
                        if(value == null || value.length<8){
                          return "please enter your password";
                        }
                        return null;
                      }, obscureText: true,
                ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: "Enter Confirm password",
                  controller: confirmController,
                  isPassword: true,
                  validator: (value){
                        if(value == null || value.isEmpty){
                          return "please enter your confirm password";
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
  buttonText: "Sign Up",
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
  }, text: 'Sign up',
),
CustomTextButton(
  text: "Already have an account? Login",
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
