// import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
as flutter_local_notifications;
import 'package:roomertenant/screens/chat.dart';

import '../main.dart';
//import '../general_exports.dart';
class PushNotificationService {
  BuildContext? context;
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();
// This function is called when ios app is opened, for android case `onDidReceiveNotificationResponse` function is called

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    FlutterAppBadger.removeBadge();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }



  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data['type'] == 'chat') {
      navigatorKey.currentState?.pushNamed(ChatScreen.id);
    }
    if(message.data['type'] == 'otp'){

    }

//     FirebaseMessaging.onMessageOpenedApp.listen(
//           (RemoteMessage message) {
//             print("MessageOpened"+message.toString());
//             print("body"+message.notification!.body.toString());
//             print("type"+message.data['type'].toString());
//             print("id"+message.data['id'].toString());
//
//             if (message.data['type'] == 'chat') {
//               navigatorKey.currentState?.pushNamed(ChatScreen.id);
//               // Navigator.push(context!, MaterialPageRoute(builder: (context) => ChatScreen('name', 'image', '6')));
//               // Navigator.pushNamed(context, '/notification', arguments: ChatArguments(notification);
//             }
//
//
//         // notificationRedirect(message.data[keyTypeValue], message.data[keyType]);
//       },
//     );
    enableIOSNotifications();
    await registerNotificationListeners();
  }
  Future<void> registerNotificationListeners() async {
    print("RegisterNotification");
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print(details.payload);

// We're receiving the payload as string that looks like this
// {buttontext: Button Text, subtitle: Subtitle, imageurl: , typevalue: 14, type: course_details}
// So the code below is used to convert string to map and read whatever property you want
        final List<String> str =
        details.payload!.replaceAll('{', '').replaceAll('}', '').split(',');
        print("MessagePayload"+str.toString());
        final Map<String, dynamic> result = <String, dynamic>{};
        for (int i = 0; i < str.length; i++) {
          final List<String> s = str[i].split(':');
          result.putIfAbsent(s[0].trim(), () => s[1].trim());
        }
        //notificationRedirect(result[keyTypeValue], result[keyType]);
      },
    );
// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print(message?.toMap().toString());
      //print(message?.data.entries.first.value);
      //consoleLog(message, key: 'firebase_message');
      final RemoteNotification? notification = message!.notification;
      final AndroidNotification? android = message.notification?.android;
      print("Android : "+message.data.entries.toString());
      print("NOTIFICATION : "+notification.toString());
      print("NOTIFICATION DATA");
      print(notification?.title.toString());
      print(notification?.body.toString());
// If `onMessage` is triggered with a notification, construct our own
// local notification to show to users using the created channel.

       // if(Platform.isAndroid && notification!=null){
       //   flutterLocalNotificationsPlugin.show(
       //     message.notification.hashCode,
       //     message?.notification?.title,
       //     message?.notification?.body,
       //     flutter_local_notifications.NotificationDetails(
       //       android: AndroidNotificationDetails(
       //         channel.id,
       //         channel.name,
       //         channelDescription: channel.description,
       //         icon: android?.smallIcon,
       //       ),
       //     ),
       //     payload: message.data.toString(),
       //   );
       // }

    });
  }
  Future<void> enableIOSNotifications() async {
    print("IOS Notify");
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );


}