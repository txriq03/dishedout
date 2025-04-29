import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);
}

void showLocalNotification(RemoteMessage message) {
  final notification = message.notification;
  final android = notification?.android;

  if (notification != null && android != null) {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
    );
  }
}

Future<void> saveNotification({
  required String title,
  required String body,
}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    print('Cannot save notification as user is null.');
    return;
  }

  await firestore
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .add({
        'title': title,
        'body': body,
        'createdAt': FieldValue.serverTimestamp(),
      });

  print('Notificaiton saved to Firestore');
}

Future<void> notifyLender({
  required String token,
  required String title,
  required String body,
}) async {
  final functions = FirebaseFunctions.instance;

  print("FCMTOKEN: $token");

  if (FirebaseAuth.instance.currentUser != null) {
    try {
      await functions.httpsCallable('sendNotificationOnClaim').call({
        'fcmToken': token,
        'title': title,
        'body': body,
      });
      print('Lender notified successfully');
    } catch (e) {
      print('Failed to notify lender: $e');
    }
  } else {
    print("ERROR: currentUser == null when notifying lender.");
  }
}
