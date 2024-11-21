import 'package:bisplit/views/group_page.dart';
import 'package:bisplit/views/pending_invitation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              Get.to(() => PendingInvitationsScreen());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.to(() => GroupScreen());
              },
              child: Text('Manage Groups'),
            ),
            // Additional buttons for other features can be added here
          ],
        ),
      ),
    );
  }
}
