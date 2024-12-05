import 'package:bisplit/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_controller.dart';

class InviteUserScreen extends StatelessWidget {
  final String groupId;
  InviteUserScreen({super.key, required this.groupId});

  final GroupController groupController = Get.find<GroupController>();
  final AuthenController authenController = Get.find<AuthenController>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String currentUserId = authenController.firebaseUser.value?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite User'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'User Email',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String userId =
                        await groupController.lookupUserIdByEmail(email);
                    if (userId.isNotEmpty) {
                      await groupController.inviteUserToGroup(groupId, userId);
                      Get.snackbar('Success', 'Invitation sent to $email');
                    } else {
                      Get.snackbar('Error', 'User not found');
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, String>>>(
              stream: groupController.getGroupMembersStream(groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No members in this group'));
                }

                List<Map<String, String>> members = snapshot.data!;
                bool isAdmin =
                    members.any((member) => member['userId'] == currentUserId);

                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];

                    return ListTile(
                      title: Text(member['displayName'] ?? ''),
                      subtitle: Text(member['email'] ?? ''),
                      trailing: isAdmin && member['userId'] != currentUserId
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () async {
                                bool confirm = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('Remove Member'),
                                        content: Text(
                                            'Are you sure you want to remove ${member['displayName']} from the group?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: true),
                                            child: const Text('Remove'),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;

                                if (confirm) {
                                  await groupController.removeUserFromGroup(
                                      groupId, member['userId']!);
                                  Get.snackbar('Success',
                                      '${member['displayName']} removed from the group');
                                }
                              },
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
