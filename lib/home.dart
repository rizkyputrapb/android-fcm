import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification/fcm_model.dart';
import 'package:flutter_notification/main.dart';
import 'package:flutter_notification/product.dart';

class HomePage extends StatefulWidget {
  final String? message;

  HomePage({Key? key, this.message}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    setupInteractedMessage();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      RemoteNotification? notification = message?.notification!;

      print(notification != null ? notification.title : '');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      final fcm = FCMDataModel.fromJson(jsonDecode(message.data['aps']));

      flutterLocalNotificationsPlugin!.show(
        notification.hashCode,
        fcm.alert?.title,
        fcm.alert?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id,
            channel!.name,
            priority: Priority.high,
            importance: Importance.max,
            setAsGroupSummary: true,
            styleInformation: DefaultStyleInformation(true, true),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            channelShowBadge: true,
            autoCancel: true,
            icon: '@drawable/ic_notifications_icon',
          ),
        ),
      );
      print('A new event was published!');
      print('FCM MESSAGE : ${notification}');
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message.data));


  }

  Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => _handleMessage(value != null ? value.data : Map()));
  }

  void _handleMessage(Map<String, dynamic> data) {
    if (data['redirect'] == "product") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductPage(message: data['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You will receive notification',
            ),
          ],
        ),
      ),
    );
  }
}
