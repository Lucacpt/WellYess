import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

// Definisci qui il plugin notifiche globale
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Callback per Android Alarm Manager: mostra la notifica all'orario programmato
@pragma('vm:entry-point')
void mostraNotificaCallback(int id, Map<String, dynamic> data) {
  // Inizializza il plugin notifiche per Android
  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  plugin.initialize(initializationSettings);

  // Recupera nome e dose dal payload della notifica
  final String nome = data['nome'] ?? 'il tuo farmaco';
  final String dose = data['dose'] ?? '';

  // Mostra la notifica con titolo e messaggio personalizzati
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

// Pianifica una notifica per un farmaco all'orario specificato
Future<void> scheduleFarmacoNotification(dynamic key, String nome, String dose, String orario) async {
  final format = DateFormat("HH:mm");
  final time = format.parse(orario);
  final int notificationId = key; // Usa la chiave Hive come ID

  if (Platform.isAndroid) {
    // Calcola la prossima occorrenza dell'orario richiesto
    final DateTime scheduledDateTime = _nextInstanceOfTime(time.hour, time.minute);
    // Usa AndroidAlarmManager per programmare la notifica
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
    // Calcola la prossima occorrenza dell'orario richiesto (timezone-aware)
    final tz.TZDateTime scheduledDateTime = _nextInstanceOfTimeTZ(time.hour, time.minute);
    // Usa il plugin notifiche per programmare la notifica su iOS
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

// Cancella una notifica programmata per un farmaco
Future<void> cancelFarmacoNotification(dynamic key) async {
  final int notificationId = key;
  if (Platform.isAndroid) {
    await AndroidAlarmManager.cancel(notificationId);
  } else if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}

// Calcola la prossima occorrenza di un orario (oggi o domani se già passato) per Android
DateTime _nextInstanceOfTime(int hour, int minute) {
  final now = DateTime.now();
  var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

// Calcola la prossima occorrenza di un orario (oggi o domani se già passato) per iOS/timezone
tz.TZDateTime _nextInstanceOfTimeTZ(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}