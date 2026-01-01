import 'package:flutter/material.dart';
import '../locator.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storage = locator<StorageService>();

  bool isDark = false;

  Future<void> loadTheme() async {
    isDark = await _storage.loadTheme();
    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;
    _storage.saveTheme(isDark);
    notifyListeners();
  }
}
