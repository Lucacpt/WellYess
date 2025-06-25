import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

// Definisci qui il plugin notifiche
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Callback per Android Alarm Manager
@pragma('vm:entry-point')
void mostraNotificaCallback(int id, Map<String, dynamic> data) {
  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  plugin.initialize(initializationSettings);

  final String nome = data['nome'] ?? 'il tuo farmaco';
  final String dose = data['dose'] ?? '';

  plugin.show(
    id,
    'Promemoria Farmaco',
    'È ora di prendere ${nome} ${dose}.',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'farmaci_channel_id',
        'Promemoria Farmaci',
        channelDescription: 'Canale per i promemoria dei farmaci.',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    payload: id.toString(),
  );
}

Future<void> scheduleFarmacoNotification(dynamic key, String nome, String dose, String orario) async {
  final format = DateFormat("HH:mm");
  final time = format.parse(orario);
  final int notificationId = key; // Usa la chiave Hive come ID

  if (Platform.isAndroid) {
    final DateTime scheduledDateTime = _nextInstanceOfTime(time.hour, time.minute);
    await AndroidAlarmManager.oneShotAt(
      scheduledDateTime,
      notificationId,
      mostraNotificaCallback,
      exact: true,
      wakeup: true,
      alarmClock: true,
      params: {
        'nome': nome,
        'dose': dose,
      },
    );
  } else if (Platform.isIOS) {
    final tz.TZDateTime scheduledDateTime = _nextInstanceOfTimeTZ(time.hour, time.minute);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '🕐 È il momento di prendere il farmaco!',
      'Hai già preso il tuo farmaco “$nome $dose"? Tocca qui per segnarlo.',
      scheduledDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'farmaci_channel_id', 'Promemoria Farmaci'
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

Future<void> cancelFarmacoNotification(dynamic key) async {
  final int notificationId = key;
  if (Platform.isAndroid) {
    await AndroidAlarmManager.cancel(notificationId);
  } else if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}

DateTime _nextInstanceOfTime(int hour, int minute) {
  final now = DateTime.now();
  var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime _nextInstanceOfTimeTZ(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}