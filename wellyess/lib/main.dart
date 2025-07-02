import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/services/auth_service.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/homepage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wellyess/screens/med_section.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Funzione di callback per Android Alarm Manager
@pragma('vm:entry-point')
void mostraNotificaCallback(int id, Map<String, dynamic> data) {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Estrai i dati passati dall'Alarm Manager
  final String nome = data['nome'] ?? 'il tuo farmaco';
  final String dose = data['dose'] ?? '';

  flutterLocalNotificationsPlugin.show(
    id,
    '🕐 È il momento di prendere il farmaco!',
    'Hai già preso il tuo farmaco “$nome $dose"? Tocca qui per segnarlo.',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'farmaci_channel_id',
        'Promemoria Farmaci',
        channelDescription: 'Canale per i promemoria dei farmaci.',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    // **LA CORREZIONE CHIAVE**: Allega l'ID come payload
    payload: id.toString(),
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? farmacoDaMostrare;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // only initialize alarm manager on non-web Android
  if (!kIsWeb && Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Rome'));

  await Hive.initFlutter();
  Hive.registerAdapter(UserTypeAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(FarmacoModelAdapter());
  Hive.registerAdapter(AppointmentModelAdapter());
  Hive.registerAdapter(ParameterEntryAdapter());

  await Hive.openBox<UserModel>('users');
  await Hive.openBox<FarmacoModel>('farmaci');
  await Hive.openBox<AppointmentModel>('appointments');
  await Hive.openBox<ParameterEntry>('parameters');
  await AuthService.init();

  await initializeDateFormatting('it_IT', null);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission:  true,
        requestSoundPermission:  true,
      );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        farmacoDaMostrare = response.payload;
        
        // **LA CORREZIONE PER LA SCHERMATA NERA**
        // 1. Vai alla HomePage e pulisci la cronologia
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
        // 2. Subito dopo, apri la pagina dei farmaci
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const FarmaciPage()),
        );
      }
    },
  );

  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  // 1) legge il tipo utente salvato (se esiste)
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('userType');

  // 2) imposta la pagina di partenza in base al valore
  final startPage = saved != null
      ? const HomePage()
      : const LoginPage();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AccessibilitaModel(),
      child: MyApp(startPage: startPage),
    ),
  );
}

/// Global route observer
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp({Key? key, required this.startPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera le impostazioni di accessibilità
    final access = context.watch<AccessibilitaModel>();
    return MaterialApp(
      title: 'WellYess',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: access.highContrast
            ? ColorScheme.light(
                primary: Colors.black,
                secondary: Colors.yellow.shade700,
                background: Colors.white,
                onPrimary: Colors.yellow.shade700,
              )
            : ColorScheme.light(
                primary: const Color(0xFF5DB47F),
                secondary: Colors.teal,
              ),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: access.fontSizeFactor,
            ),
      ),
      home: startPage,
    );
  }
}