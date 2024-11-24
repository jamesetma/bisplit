import 'package:bisplit/views/group_page.dart';
import 'package:bisplit/views/notification_page.dart';
import 'package:bisplit/views/pending_invitation_page.dart';
import 'package:bisplit/views/profile_page.dart';
import 'package:bisplit/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Get.to(() => NotificationsScreen());
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Get.to(() => ProfilePage());
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.to(() => SettingsScreen());
            },
          ),
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
              child: Text('manage_groups'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
