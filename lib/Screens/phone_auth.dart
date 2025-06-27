import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String? verificationId;
  bool otpSent = false;

  Future<void> sendOTP() async {
    final phone = phoneController.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto login on Android if possible
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed: ${e.message}")));
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          otpSent = true;
          verificationId = verId;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP Sent")));
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOTP() async {
    final otp = otpController.text.trim();

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone Login Successful")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Auth')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: 'Enter Phone Number'),
            ),
            if (otpSent)
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter OTP'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: otpSent ? verifyOTP : sendOTP,
              child: Text(otpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
