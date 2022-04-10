import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

class Reminder extends StatefulWidget {
  Reminder({Key? key}) : super(key: key);

  @override
  ReminderState createState() => ReminderState();
}

class ReminderState extends State<Reminder> {

  static final notification = FlutterLocalNotificationsPlugin();

  static Future showNotification(
          {int id = 0,
          String? title,
          String? body,
          required DateTime scheduledDate}) async {
  var scheduledNotificationsDateTime = scheduledDate;
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'ic_launcher',
    largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(0, title, body,
      scheduledNotificationsDateTime, platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Event"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
          ),
        ),
      ),
    );
  }
}
