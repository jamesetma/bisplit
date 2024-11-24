import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <String>[].obs;

  void addNotification(String notification) {
    notifications.add(notification);
  }

  void clearNotifications() {
    notifications.clear();
  }
}
