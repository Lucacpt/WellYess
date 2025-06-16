import 'package:flutter/material.dart';
import 'package:wellyess/services/auth_service.dart';
import 'package:wellyess/screens/homepage.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/profilo_caregiver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final startPage = AuthService.isLoggedIn
        ? (AuthService.currentUser == UserType.elder
            ? const HomePage()
            : const CaregiverProfilePage())
        : const LoginPage();

    return MaterialApp(
      title: 'WellYess',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: startPage,
    );
  }
}
