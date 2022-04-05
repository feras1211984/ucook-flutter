import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ucookfrontend/features/data/datasources/databases/notifications_database.dart';
import '../../features/data/models/notification.dart';
import '../../features/presentation/bloc/notifications/notifications_events.dart';
import '../../features/presentation/utils/routes.dart';
import '../../shared_variables_and_methods.dart';

late FirebaseMessaging firebaseMessaging;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationsDatabase.save(Notification.fromMessage(message));
}

Future<void> initializeFirebaseCloudMessagingService() async {
  try {
    await Firebase.initializeApp();
    firebaseMessaging = FirebaseMessaging.instance;
    showtInitialNotification();
    firebaseMessaging.subscribeToTopic('ucook');

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationsBloc.add(NotificationReceived(
          notification: Notification.fromMessage(message)));

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Notification notification = Notification.fromMessage(message);
      navigator.currentState
          ?.pushNamed(NOTIFICATION_ROUTE, arguments: notification);
      notificationsBloc.add(OpenNotification(notification: notification));
    });
  } catch (e) {}
}

Future<void> showtInitialNotification() async {
  try {
    RemoteMessage? message = await firebaseMessaging.getInitialMessage();
    if (message != null) {
      Notification notification = Notification.fromMessage(message);
      navigator.currentState
          ?.pushNamed(NOTIFICATION_ROUTE, arguments: notification);
      notificationsBloc.add(OpenNotification(notification: notification));
    }
  } catch (e) {}
}
