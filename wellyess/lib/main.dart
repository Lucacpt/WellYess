import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/services/auth_service.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/homepage.dart';
import 'package:wellyess/screens/profilo_caregiver.dart';
import 'package:intl/date_symbol_data_local.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserTypeAdapter());        // 0
  Hive.registerAdapter(UserModelAdapter());       // 1
  Hive.registerAdapter(FarmacoModelAdapter());    // 2
  Hive.registerAdapter(AppointmentModelAdapter()); // 3
  Hive.registerAdapter(ParameterEntryAdapter());   // <— registra il model

  await Hive.openBox<UserModel>('users');
  await Hive.openBox<FarmacoModel>('farmaci');
  await Hive.openBox<AppointmentModel>('appointments');
  await Hive.openBox<ParameterEntry>('parameters'); // <— apri la box
  await AuthService.init();

  // 2. Inizializza i dati per la lingua italiana prima di avviare l'app
  await initializeDateFormatting('it_IT', null);
  debugPrint('ℹ️ isLoggedIn = ${AuthService.isLoggedIn}');  // <-- vedi in console
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // In modo che non appaia più la schermata bianca se c'è un errore di build:
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        body: Center(
          child: Text(
            details.exceptionAsString(),
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    };

    final startPage = AuthService.isLoggedIn
        ? (AuthService.currentUser!.type == UserType.elder
            ? const HomePage()
            : const CaregiverProfilePage())
        : const LoginPage();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startPage,
    );
  }
}