import 'package:buddymensia/screens/home/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize(BuildContext context) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
    );
    print('bikin notifikasi');
  }

  Future<void> scheduleSingleNotification(
      String title, DateTime date, int id) async {
    var scheduledNotificationDateTime = date;

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'medication_reminder_channel',
      'Medication Reminders',
      channelDescription: 'Channel for medication reminders',
      icon: 'mipmap/ic_launcher',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    print('dibuat disini');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Pengingat Jadwal',
      title,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      platformChannelSpecifics,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  Future<void> showNotificationNow(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'medication_reminder_channel', // channel ID
      'Medication Reminders', // channel name
      channelDescription:
          'Channel for medication reminders', // channel description
      icon: 'mipmap/ic_launcher',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    print('notifikasi');
    await flutterLocalNotificationsPlugin.show(
      0, // id
      title, // title
      body, // body
      platformChannelSpecifics,
      payload: 'item x', // optional
    );
  }
}
