import 'package:bisplit/controllers/notification_controller.dart';
import 'package:bisplit/views/notification_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Initialize flutter_local_notifications plugin (if you're using it)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> handleBackgroundMsg(RemoteMessage msg) async {
  // Display a local notification (if you're using flutter_local_notifications)
  // ...
}

class NotificationService extends GetxService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      print('Token: $fCMToken');
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      // Replace with your app icon
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Store FCM token on your server (if needed)

      // Initialize local notifications plugin (if you're using it)
      // ...

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMsg);
      initPushNotifications();
    } catch (e) {
      print('Error initializing notifications: $e');
      // Handle the error, e.g., display an error message
    }
  }

  Future<void> initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    // Get initial message for when the app is launched from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      print('getInitialMessage: $msg'); // Debug print
      handleMsg(msg);
    });

    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((msg) {
      print('onMessage: $msg'); // Debug print
      handleMsg(msg);
    });

    // Listen for messages when the app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      print('onMessageOpenedApp: $msg'); // Debug print
      handleMsg(msg);
    });
  }

  void handleMsg(RemoteMessage? msg) {
    if (msg == null) return;
    print('handleMsg called with message: $msg'); // Debug print
    Get.find<NotificationsController>().addNotification(msg);
    Get.to(() => NotificationsScreen(), arguments: msg);
  }
}
