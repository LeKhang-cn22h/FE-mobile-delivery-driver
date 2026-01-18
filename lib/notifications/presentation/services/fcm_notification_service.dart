import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmNotificationService {
  static void listenForMessages(BuildContext context) {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notification.body ?? 'Thông báo mới'),
          duration: const Duration(seconds: 3),
        ),
      );
    });

    // Background tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // TODO: handle deep link
    });
  }
}
