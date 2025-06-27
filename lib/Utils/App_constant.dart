// ignore: unused_import
import 'package:flutter/material.dart';

class AppConstants {
  // General
  static const String appName = "TaskBuddy";
  static const String title = "Login Page";
  static const String Signuptitle = "Sign Up";
  static const String defaultFontFamily = "Roboto";

  // Firebase
  static const String apiKey = "AIzaSyAfIx2L0mLzpaMicZiiTJ4FV7Du4dvc_HE";
  static const String appId = "1:68741067855:android:8dc635aaf9fbcf9fa6263a";
  static const String messagingSenderId = "68741067855";
  static const String projectId = "taskbuddy-ca032";
  static const String storageBucket = "taskbuddy-ca032.firebasestorage.app";
  


  // Buttons
  static const String ForgotButton = "Forgot Password";
  static const String LoginButton = "Login";
  static const String SignupButton = "Sign Up";
  static const String IHaveButton = "Already have an account? Login";
  static const String DonotButton = "Don't have an account? Sign Up";
  
  
  // Padding and spacing
  static const double screenPadding = 20.0;
  static const double elementSpacing = 10.0;

  // Auth messages
  static const String loginSuccess = "Login Successful ✅";
  
  static const String SignupSuccess = "Sign up Successful ✅";
  static const String loginFailed = "Login failed: ";
  static const String SignupFailed = "Signup failed: ";
  static const String emptyEmailError = "Please enter your email";
  static const String invalidEmailError = "Enter a valid email";
  static const String emptyPasswordError = "Please enter your password";
  static const String emptyconfirmPasswordError = "Please enter your confirm password";
  static const String donotmatchPasswordError = "Passwords do not match";
  static const String shortPasswordError = "Password must be at least 8 characters";

  // Durations
  static const Duration snackbarDuration = Duration(seconds: 2);

  //hint text
  static const String EnterEmail = "Enter Email";
  static const String EnterPassword = "Enter Password";
  static const String EnterConfirmPassword = "Enter Confirm password";

  //text
  static const String Signuptext = "Sign up";
}
