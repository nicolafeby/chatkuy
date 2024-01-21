import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fcmToken = await _firebaseMessaging.getToken();
    log("Token: $fcmToken");
    initPushNotifications();
  }
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  log("Title: ${message.notification?.title}");
  log("Body: ${message.notification?.body}");
  log("Payload: ${message.data}");
}

void handleMessage(RemoteMessage? message) {
  log("ini message: $message");
  if (message == null) return;

  // navigatorKey.currentState?.pushNamed(
  //   RouterConstant.notificationPage,
  //   arguments: NotificationArgument(
  //     title: message.notification?.title ?? '',
  //     desc: message.notification?.body ?? '',
  //     data: message.data,
  //   ),
  // );
}

Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
}
