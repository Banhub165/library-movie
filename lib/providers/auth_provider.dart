import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _loading = false;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  bool get loading => _loading;
  String? get error => _error;

  AuthProvider() {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user_$email')) {
      _error = "Email sudah terdaftar";
      notifyListeners();
      return false;
    }

    await prefs.setString('user_$email', password);
    _error = null;
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString('user_$email');

    await Future.delayed(const Duration(milliseconds: 800));

    if (storedPassword == password) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('currentUser', email);
      _isLoggedIn = true;
      _loading = false;
      notifyListeners();
      return true;
    } else {
      _error = "Email atau password salah";
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('currentUser');
    _isLoggedIn = false;
    notifyListeners();
  }
}
