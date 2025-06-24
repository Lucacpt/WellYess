import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/services/auth_service.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/homepage.dart';
import 'package:intl/date_symbol_data_local.dart';

// MODIFICA: La funzione main è ora asincrona per completare l'init prima di runApp.
Future<void> main() async {
  // Assicura che i binding di Flutter siano pronti.
  WidgetsFlutterBinding.ensureInitialized();

  // Esegue tutta la logica di inizializzazione qui.
  await Hive.initFlutter();
  Hive.registerAdapter(UserTypeAdapter()); // 0
  Hive.registerAdapter(UserModelAdapter()); // 1
  Hive.registerAdapter(FarmacoModelAdapter()); // 2
  Hive.registerAdapter(AppointmentModelAdapter()); // 3
  Hive.registerAdapter(ParameterEntryAdapter()); // 4

  await Hive.openBox<UserModel>('users');
  await Hive.openBox<FarmacoModel>('farmaci');
  await Hive.openBox<AppointmentModel>('appointments');
  await Hive.openBox<ParameterEntry>('parameters');
  await AuthService.init();

  await initializeDateFormatting('it_IT', null);
  debugPrint('ℹ️ App Initialized. isLoggedIn = ${AuthService.isLoggedIn}');

  // Solo ora, con tutto pronto, avviamo l'app.
  runApp(const MyApp());
}

// MODIFICA: MyApp è ora un semplice StatelessWidget, non ha più bisogno del FutureBuilder.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // In questo punto, AuthService.isLoggedIn ha già il valore corretto e affidabile.
    final startPage =
        AuthService.isLoggedIn ? const HomePage() : const LoginPage();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startPage,
    );
  }
}