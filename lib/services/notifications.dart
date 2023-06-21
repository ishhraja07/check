import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin localNotifPlugin =
      FlutterLocalNotificationsPlugin();
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    print("device token: ${await messaging.getToken()}");
  }

  void checkNotifications() async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iosInitialize = DarwinInitializationSettings();

    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    localNotifPlugin.initialize(
      initializationsSettings,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message.notification");

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          const AndroidNotificationDetails(
        'team_swami',
        'team_swami',
        importance: Importance.max,
        priority: Priority.max,
        playSound: false,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await localNotifPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
      );
      // print("payload ${message.data['mou_id']}");
    });
  }

  void sendPushMessage(String body, String title) async {
    try {
      var responce =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAW8_i2MI:APA91bHhIkHDt8qJGaJjH37orZOSorumqtqTxzuEnXDPOoYExCTiVISdGUauI3xpNEGX_l0OiRumcXLy5om5U501dnm3ipGtJezSJrX2vpe4G1vrjP-brDi5LUnlxGc_efbhuuMxQD4e'
              },
              body: jsonEncode(<String, dynamic>{
                "notification": <String, dynamic>{
                  "body": body,
                  "title": title,
                },
                'to': '/topics/swami',
                'priority': 'high',
                'data': <String, dynamic>{
                  "click_action": "FLUTTER_NOTIFICATION_CLICK",
                  "id": "1",
                  "status": "done",
                  "body": body,
                  "title": title
                }
              }));
    } catch (e) {
      // print(e);
    }
  }
}
