import 'package:bisplit/views/authgate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((value) => Get.offAll(() => AuthGate()));
            },
          ),
        ],
      ),
      body: Center(
          child: Text("Welcome, ${FirebaseAuth.instance.currentUser?.email}!")),
    );
  }
}
