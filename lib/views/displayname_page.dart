import 'package:bisplit/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class DisplayNameScreen extends StatelessWidget {
  final AuthenController authController = Get.find<AuthenController>();
  final TextEditingController displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Display Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            ElevatedButton(
              onPressed: () async {
                String displayName = displayNameController.text.trim();
                if (displayName.isNotEmpty) {
                  await authController.updateDisplayName(displayName);
                  Get.offAll(() => HomePage());
                } else {
                  Get.snackbar('Error', 'Display name cannot be empty');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
