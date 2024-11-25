import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final _notifications = <RemoteMessage>[].obs;

  List<RemoteMessage> get notifications => _notifications;

  void addNotification(RemoteMessage notification) {
    _notifications.add(notification);
  }
}
