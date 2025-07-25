import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/homepage.dart';
// MODIFICA: L'import di profilo_caregiver non è più necessario qui.
import 'package:wellyess/widgets/custom_main_button.dart';

// Pagina di login per l'applicazione
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller per i campi email e password
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false; // Stato di caricamento per il pulsante

  // Credenziali fisse per il prototipo (anziano e caregiver)
  static const String elderEmail = "anziano";
  static const String elderPass = "password";
  static const String caregiverEmail = "caregiver";
  static const String caregiverPass = "password";

  // Gestisce il login dell'utente
  Future<void> _handleLogin() async {
    setState(() => _loading = true);

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    UserType? loggedInUserType;

    // Verifica le credenziali inserite
    if (email == elderEmail && pass == elderPass) {
      loggedInUserType = UserType.elder;
    } else if (email == caregiverEmail && pass == caregiverPass) {
      loggedInUserType = UserType.caregiver;
    }

    if (loggedInUserType != null) {
      // Salva il tipo di utente nelle SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', loggedInUserType.toString());

      // MODIFICA: Ora entrambi gli utenti vengono reindirizzati alla HomePage.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } else {
      // Mostra un dialog di errore se le credenziali non sono valide
      _showErrorDialog(context);
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  // Mostra un dialog di errore per credenziali non valide
  Future<void> _showErrorDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          contentPadding: EdgeInsets.all(screenWidth * 0.05),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Credenziali non valide.\nPer favore, riprova.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                ),
                child: Icon(Icons.close,
                    color: Colors.white, size: screenWidth * 0.07),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ottieni dimensioni schermo per layout responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.08),
                // Logo dell'applicazione
                SizedBox(
                  height: screenHeight * 0.12,
                  child: Image.asset('assets/logo/wellyess.png'),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Titolo di benvenuto
                Text(
                  'Bentornato!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                // Sottotitolo
                Text(
                  'Accedi per continuare',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Campo email
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Semantics(
                    label: 'Email utente',
                    hint: 'Inserisci l’email',
                    textField: true,
                    child: TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Campo password
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outlined,
                          color: Colors.grey.shade600),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                // Link per password dimenticata (non implementato)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Azione non implementata per il prototipo
                    },
                    child: Text(
                      'Password dimenticata?',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Pulsante di login o loader se in caricamento
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomMainButton(
                        text: 'Accedi',
                        color: const Color(0xFF5DB47F),
                        onTap: _handleLogin,
                      ),
                SizedBox(height: screenHeight * 0.05),
                // Link per la registrazione (non implementato)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Non hai un account?",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenWidth * 0.045),
                    ),
                    TextButton(
                      onPressed: () {
                        // Azione non implementata per il prototipo
                      },
                      child: Text(
                        "Registrati",
                        style: TextStyle(
                          color: const Color(0xFF5DB47F),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}