import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  String? token;
  User? user;

  bool isLoading = false;
  String? errorMessage;

  AuthProvider({required this.authService});

  bool get isAuthenticated => token != null;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await authService.login(email: email, password: password);

      token = data['token'];
      user = User.fromJson(data['user']);

      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    token = null;
    user = null;
    notifyListeners();
  }
}
