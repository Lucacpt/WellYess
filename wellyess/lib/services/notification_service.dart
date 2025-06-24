import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wellyess/main.dart'; // Per accedere a flutterLocalNotificationsPlugin

void sendFarmacoNotification(String farmacoKey, String nomeFarmaco) async {
  await flutterLocalNotificationsPlugin.show(
    0,
    'È ora di assumere il farmaco',
    'Hai assunto $nomeFarmaco?',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'farmaci_channel',
        'Farmaci',
        channelDescription: 'Notifiche per assunzione farmaci',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    payload: farmacoKey,
  );
}