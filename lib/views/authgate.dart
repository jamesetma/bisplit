import 'package:bisplit/views/home_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SignInScreen(
        styles: const {
          EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
        },
        providers: [
          EmailAuthProvider(),
        ],
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Get.offAll(HomePage());
          }),
        ],
      ),
    );
  }
}
