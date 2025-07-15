import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Utils/Theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool showPasswordForm = false;

  final _formKey = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  bool isLoading = false;

  Future<void> getUserData() async {
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = snapshot.data();
      });
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (newPassword != confirmPassword) {
      showSnackbar("New password and Confirm password do not match");
      return;
    }

    try {
      setState(() => isLoading = true);
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user!.reauthenticateWithCredential(credential);
      await user!.updatePassword(newPassword);
      showSnackbar("Password updated successfully!");
      setState(() {
        showPasswordForm = false;
      });
    } catch (e) {
      showSnackbar("Error: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'No Name';
    final email = user?.email ?? 'No Email';
    final base64Image = userData?['photo'];
    Uint8List? imageBytes =
        base64Image != null ? base64Decode(base64Image) : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ListView(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          imageBytes != null ? MemoryImage(imageBytes) : null,
                      child: imageBytes == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(name),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(email,
                        ),
                  ),
                  const SizedBox(height: 24),

                  /// Change Password Tile
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: Colors.deepPurple),
                    title: Text("Change Password",
                        ),
                    trailing: Icon(Icons.arrow_drop_down),
                    onTap: () {
                      setState(() {
                        showPasswordForm = !showPasswordForm;
                      });
                    },
                  ),

                  /// Password form
                  if (showPasswordForm) buildPasswordForm(),
                ],
              ),
            ),
    );
  }

  Widget buildPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPasswordField("Old Password", (val) => oldPassword = val!),
          const SizedBox(height: 12),
          buildPasswordField("New Password", (val) => newPassword = val!),
          const SizedBox(height: 12),
          buildPasswordField(
              "Confirm Password", (val) => confirmPassword = val!),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Update Password",
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget buildPasswordField(String label, FormFieldSetter<String> onSaved) {
    return TextFormField(
      obscureText: true,
      onSaved: onSaved,
      validator: (val) =>
          val == null || val.length < 6 ? "Enter min 6 characters" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ));
  }}