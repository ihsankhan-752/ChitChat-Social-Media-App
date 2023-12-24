// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../models/notification_model.dart';
import '../utils/constants.dart';
import '../utils/custom_messanger.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void getPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('Request Granted');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("Provisional State Granted");
      }
    } else {
      return null;
    }
  }

  getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null && FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection('tokens')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token});
    }
  }

  void initNotification(BuildContext context) async {
    RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      if (kDebugMode) {
        print(
            "Get Message in Terminated State :${remoteMessage.notification!.title}");
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        if (Platform.isAndroid) {
          print(
              "Get Notification in Foreground State ${remoteMessage.notification!.title}");
          initLocalNotifications(context, remoteMessage);
          showNotification(context, remoteMessage);
        } else {
          showNotification(context, remoteMessage);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        if (kDebugMode) {
          print(
              "Get Notification in background State :${remoteMessage.notification!.title}");
        }
      }
    });
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handleMessage(context, message, message.data['userId']);
    });
  }

  Future<void> showNotification(
      BuildContext context, RemoteMessage message) async {
    initLocalNotifications(context, message);
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }

  sendPushNotification(
      {required String userId,
      required String body,
      required String title}) async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('tokens')
          .doc(userId)
          .get();

      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": messagingKey,
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": '1',
              "status": "done",
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              // "android_channel_id": "abc",
            },
            "to": snap['token'],
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  addNotificationInDB({
    required BuildContext context,
    required String toUserId,
    required String title,
    required String userImage,
  }) async {
    try {
      String docId = const Uuid().v4();

      NotificationModel notificationModel = NotificationModel(
        fromUserId: FirebaseAuth.instance.currentUser!.uid,
        toUserId: toUserId,
        title: title,
        createdAt: DateTime.now(),
        docId: docId,
        userImage: userImage,
      );
      await FirebaseFirestore.instance
          .collection('notification')
          .doc(docId)
          .set(notificationModel.toMap());
    } on FirebaseException catch (e) {
      showMessage(context, e.message!);
    }
  }
}
