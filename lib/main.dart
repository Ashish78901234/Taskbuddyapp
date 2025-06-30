import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/login.dart';
import 'package:flutter_application_1/Screens/sing_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/Utils/App_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
  options: const FirebaseOptions(
  apiKey: AppConstants.apiKey,
  appId: AppConstants.appId,
  messagingSenderId: AppConstants.messagingSenderId,
  projectId: AppConstants.projectId,
  storageBucket: AppConstants.storageBucket,
),

);
  runApp(const TaskBuddyApp());
}
class TaskBuddyApp extends StatelessWidget {
  const TaskBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.title,
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
