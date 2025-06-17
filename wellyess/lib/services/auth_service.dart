enum UserType { elder, caregiver }

class AuthService {
  static UserType? _currentUser;
  static bool get isLoggedIn => _currentUser != null;
  static UserType? get currentUser => _currentUser;

  /// Simula login: in un’app reale qui fai la chiamata a backend/Firebase
  static Future<bool> login(String email, String password, UserType type) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = type;
    return true;
  }

  static void logout() {
    _currentUser = null;
  }
}