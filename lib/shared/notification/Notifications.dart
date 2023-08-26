import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trade_market_app/data/models/dataModel/DataModel.dart';

class Notifications {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings android = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  final DarwinInitializationSettings ios = const DarwinInitializationSettings();


  Future<void> initialize() async {

    final InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  }



  Future<void> getNotification({
    required String title,
    required String body,
  }) async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }


  void onMessageListener() async {

    FirebaseMessaging.onMessage.listen((event) async {

      Data data = Data.fromJson(event.data);

      if((data.title != null) && (data.message != null)) {

        await getNotification(title: data.title ?? '', body: data.message ?? '');

      }

      if (kDebugMode) {
        print('Notification from foreground : ${event.data}');
      }

    });

  }


}