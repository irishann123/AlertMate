import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'rem.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "Schedule Reminder",
        "Don't forget to drink water",
        channelDescription: "Channel description",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  static Future init(GlobalKey<NavigatorState> navigatorKey, String uid) async {
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: (payload) async {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => AllReminderPage()),
        );
        onNotifications.add(payload as String?);
      },
    );
  }

  static Future showNotifications({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    // Check if the current time matches the start time to ring the alarm
    if (DateTime.now().isAtSameMomentAs(startTime)) {
      // Schedule the first notification
      await _notifications.zonedSchedule(
        id, // Unique ID for the notification
        title,
        body,
        tz.TZDateTime.from(startTime, tz.local),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      // Calculate the time difference between the start time and end time
      Duration difference = endTime.difference(startTime);
      // Convert the duration to minutes
      int minutesDifference = difference.inMinutes;

      // Schedule subsequent notifications every 15 minutes till the end time
      for (int i = 15; i <= minutesDifference; i += 15) {
        // Calculate the time for the next notification
        DateTime nextNotificationTime = startTime.add(Duration(minutes: i));
        // Schedule the next notification
        await _notifications.zonedSchedule(
          id + i, // Unique ID for each notification
          title,
          body,
          tz.TZDateTime.from(nextNotificationTime, tz.local),
          await _notificationDetails(),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  }
}
