import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(notificationController.notifications[index]),
            );
          },
        );
      }),
    );
  }
}
