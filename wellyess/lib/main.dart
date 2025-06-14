import 'package:flutter/material.dart';
import 'screens/homepage.dart'; // Assicurati che questo file esista nella cartella lib/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Progetto IUM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true, // Opzionale, per lo stile Material 3
      ),
      home: HomePage(), // HomePage deve essere definita in homepage.dart
    );
  }
}
