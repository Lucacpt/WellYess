import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthService {
  static late Box<UserModel> _userBox;

  static Future<void> init() async {
    _userBox = await Hive.openBox<UserModel>('users');
  }

  static Future<bool> login(String email, String password, UserType type) async {
    final user = UserModel(email: email, type: type);
    await _userBox.put('current', user);
    return true;
  }

  static UserModel? get currentUser => _userBox.get('current');
  static bool get isLoggedIn => currentUser != null;

  static Future<void> logout() async {
    await _userBox.clear();
  }
}