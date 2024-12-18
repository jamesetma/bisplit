import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_controller.dart';

class PendingInvitationsScreen extends StatelessWidget {
  final GroupController groupController = Get.find<GroupController>();

  PendingInvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Invitations'),
      ),
      body: FirestoreListView<Map<String, dynamic>>(
        query: groupController.getPendingInvitationsQuery(),
        itemBuilder: (context, snapshot) {
          var invitation = snapshot.data();
          var groupId = invitation['groupId'];
          var invitationId = snapshot.id;

          return ListTile(
            title: Text('Group ID: $groupId'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    groupController.acceptGroupInvitation(invitationId);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    groupController.rejectGroupInvitation(invitationId);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
