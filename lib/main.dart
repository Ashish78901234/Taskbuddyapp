import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/login.dart';
import 'package:flutter_application_1/Screens/sing_up.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_application_1/Screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
  options: const FirebaseOptions(
  apiKey: "AIzaSyAfIx2L0mLzpaMicZiiTJ4FV7Du4dvc_HE",
  appId: "1:68741067855:android:8dc635aaf9fbcf9fa6263a",
  messagingSenderId: "68741067855",
  projectId: "taskbuddy-ca032",
  storageBucket: "taskbuddy-ca032.firebasestorage.app",
),

);
  runApp(const TaskBuddyApp());
}
class TaskBuddyApp extends StatelessWidget {
  const TaskBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginScreen(),
       '/signup': (context) => const SignupScreen(),
      });
      }
  }
