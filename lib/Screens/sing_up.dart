import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Screens/login.dart';
import 'package:flutter_application_1/Utils/App_constant.dart';
import 'package:flutter_application_1/Utils/SnackBar.dart';
import 'package:flutter_application_1/Utils/Theme.dart';
import 'package:flutter_application_1/Utils/password_validation.dart';
import 'package:flutter_application_1/Widget/Button.dart';
import 'package:flutter_application_1/Widget/Text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  io.File? _imageFile; // Mobile
  Uint8List? _webImageBytes; // Web

  bool isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();  // image picker
    final picked = await picker.pickImage(
      source: ImageSource.gallery,   //select image from gallery
      imageQuality: 25,
    );
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
      } else {
        setState(() {
          _imageFile = io.File(picked.path);
        });
      }
    }
  }
       // create a functon signup
  void signUpUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty ||
        (!kIsWeb && _imageFile == null) ||
        (kIsWeb && _webImageBytes == null)) {
          // this is Snackbar for messages
      CustomSnackBar.show(context,
          message: AppConstants.fillAllFields, isError: true);
      return;
    }
         // this is password validation message
    if (password != confirm) {
      CustomSnackBar.show(context,
          message: AppConstants.donotmatchPasswordError, isError: true);
      return;
    }

    final passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      CustomSnackBar.show(context, message: passwordError, isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      // email authtion 
      final userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Convert image to Base64
      String base64Image = base64Encode(
          kIsWeb ? _webImageBytes! : await _imageFile!.readAsBytes());
      // Save to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCred.user!.uid)
          .set({
        'uid': userCred.user!.uid,
        'name': name,
        'email': email,
        'photo': base64Image,
      });
      // Sign up success
      CustomSnackBar.show(context, message: AppConstants.SignupSuccess);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // sign up faild
      CustomSnackBar.show(context,
          message: "${AppConstants.SignupFailed} ${e.message}", isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.Signuptitle),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: kIsWeb
                      ? (_webImageBytes != null
                          ? MemoryImage(_webImageBytes!)
                          : null)
                      : (_imageFile != null
                          ? Image.file(_imageFile!).image
                          : null),
                  child: (kIsWeb && _webImageBytes == null) ||
                          (!kIsWeb && _imageFile == null)
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: "Enter name", controller: nameController, obscureText: false,),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: AppConstants.EnterEmail,obscureText: false, controller: emailController),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: AppConstants.EnterPassword,
                  controller: passwordController,
                  obscureText: false,
                  isPassword: true),
              const SizedBox(height: 10),
              CustomTextField(
                  hintText: AppConstants.EnterConfirmPassword,
                  controller: confirmController,
                  obscureText: false,
                  isPassword: true),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: AppConstants.Signuptitle,
                      onPressed: signUpUser, buttonText: 'Sign up',
                    ),
              const SizedBox(height: 10),
              CustomTextButton(
                text: AppConstants.IHaveButton,
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ));
  }}
