import 'package:bisplit/models/group_model.dart';
import 'package:bisplit/views/group_details.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_controller.dart';
import '../controllers/expense_controller.dart';
import '../controllers/auth_controller.dart';

class GroupScreen extends StatelessWidget {
  final GroupController groupController = Get.find<GroupController>();
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final AuthenController authController = Get.find<AuthenController>();

  @override
  Widget build(BuildContext context) {
    final String userId =
        authController.firebaseUser.value?.uid ?? ''; // Get the current user ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: FirestoreListView<Group>(
        query: groupController.getUserGroupsQuery(userId),
        itemBuilder: (context, snapshot) {
          final group = snapshot.data();
          return ListTile(
            title: Text(group.name),
            subtitle:
                Text('Admin: ${authController.auth.currentUser!.displayName}'),
            onTap: () {
              Get.to(() => GroupDetailScreen(group: group));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateGroupBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateGroupBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Group Name'),
              ),
              ElevatedButton(
                onPressed: () {
                  final String userId =
                      authController.firebaseUser.value?.uid ??
                          ''; // Get the current user ID
                  groupController.createGroup(nameController.text, userId);
                  Navigator.pop(context);
                },
                child: Text('Create Group'),
              ),
            ],
          ),
        );
      },
    );
  }
}
