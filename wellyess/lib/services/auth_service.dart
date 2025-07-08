import 'package:hive/hive.dart';
import '../models/user_model.dart';

// Servizio di autenticazione per la gestione dell'utente loggato
class AuthService {
  // Box Hive per la persistenza degli utenti
  static late Box<UserModel> _userBox;

  // Inizializza il box Hive per gli utenti
  static Future<void> init() async {
    _userBox = await Hive.openBox<UserModel>('users');
  }

  // Effettua il login salvando l'utente corrente nel box
  static Future<bool> login(String email, String password, UserType type) async {
    final user = UserModel(email: email, type: type); // Crea un nuovo utente
    await _userBox.put('current', user); // Salva l'utente come "current"
    return true; // Login sempre valido (mock)
  }

  // Restituisce l'utente attualmente loggato (se presente)
  static UserModel? get currentUser => _userBox.get('current');

  // Restituisce true se c'è un utente loggato
  static bool get isLoggedIn => currentUser != null;

  // Effettua il logout cancellando tutti gli utenti dal box
  static Future<void> logout() async {
    await _userBox.clear();
  }
}