import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_controller.dart';

class InviteUserScreen extends StatelessWidget {
  final GroupController groupController = Get.find<GroupController>();
  final String groupId;

  InviteUserScreen({required this.groupId});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'User Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Lookup the user by email to get their user ID
                String userId = await groupController
                    .lookupUserIdByEmail(emailController.text);
                if (userId.isNotEmpty) {
                  groupController.inviteUserToGroup(groupId, userId);
                  Navigator.pop(context);
                } else {
                  // Show error message
                  Get.snackbar('Error', 'User not found');
                }
              },
              child: Text('Invite User'),
            ),
          ],
        ),
      ),
    );
  }
}
