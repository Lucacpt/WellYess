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
  // Inizializza il plugin delle notifiche locali
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

  // Mostra la notifica locale con titolo e messaggio personalizzati
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
    // Allega l'ID come payload per gestire il tap sulla notifica
    payload: id.toString(),
  );
}

// Plugin globale per le notifiche locali
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// Chiave globale per la navigazione
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// Variabile per gestire quale farmaco mostrare dopo il tap sulla notifica
String? farmacoDaMostrare;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza Alarm Manager solo su Android non web
  if (!kIsWeb && Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  // Inizializza i fusi orari per le notifiche pianificate
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Rome'));

  // Inizializza Hive e registra gli adapter per i modelli
  await Hive.initFlutter();
  Hive.registerAdapter(UserTypeAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(FarmacoModelAdapter());
  Hive.registerAdapter(AppointmentModelAdapter());
  Hive.registerAdapter(ParameterEntryAdapter());

  // Apre le box Hive per i dati persistenti
  await Hive.openBox<UserModel>('users');
  await Hive.openBox<FarmacoModel>('farmaci');
  await Hive.openBox<AppointmentModel>('appointments');
  await Hive.openBox<ParameterEntry>('parameters');
  await AuthService.init();

  // Inizializza la localizzazione italiana per le date
  await initializeDateFormatting('it_IT', null);

  // Impostazioni di inizializzazione per notifiche Android e iOS
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

  // Inizializza il plugin delle notifiche locali e gestisce il tap sulla notifica
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        farmacoDaMostrare = response.payload;
        
        // CORREZIONE: Naviga prima alla HomePage e poi alla pagina dei farmaci
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const FarmaciPage()),
        );
      }
    },
  );

  // Richiede permessi speciali per le notifiche esatte su Android
  if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  // Recupera il tipo utente salvato (se esiste) dalle preferenze
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString('userType');

  // Imposta la pagina di partenza in base al valore salvato
  final startPage = saved != null
      ? const HomePage()
      : const LoginPage();

  // Avvia l'app con il provider per l'accessibilità
  runApp(
    ChangeNotifierProvider(
      create: (_) => AccessibilitaModel(),
      child: MyApp(startPage: startPage),
    ),
  );
}

/// Osservatore globale delle rotte per gestire eventi di navigazione
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp({Key? key, required this.startPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera le impostazioni di accessibilità dal provider
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
      home: startPage, // Pagina iniziale (login o home)
    );
  }
}