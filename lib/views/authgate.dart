import 'package:bisplit/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:bisplit/controllers/auth_controller.dart';

class AuthGate extends StatelessWidget {
  final AuthenController authController = Get.find<AuthenController>();

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Get.offAll(() => HomePage());
        }),
      ],
    );
  }
}
