import 'package:bisplit/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  final NotificationsController controller =
      Get.find<NotificationsController>();

  @override
  Widget build(BuildContext context) {
    // Access the notification data passed as an argument
    final RemoteMessage? initialNotification = Get.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.notifications.length +
              (initialNotification != null
                  ? 1
                  : 0), // Include initial notification
          itemBuilder: (context, index) {
            if (index == 0 && initialNotification != null) {
              return ListTile(
                title:
                    Text(initialNotification.notification?.title ?? 'No title'),
                subtitle:
                    Text(initialNotification.notification?.body ?? 'No body'),
              );
            } else {
              final notification = controller
                  .notifications[index - (initialNotification != null ? 1 : 0)];
              return ListTile(
                title: Text(notification.notification?.title ?? 'No title'),
                subtitle: Text(notification.notification?.body ?? 'No body'),
              );
            }
          },
        ),
      ),
    );
  }
}
