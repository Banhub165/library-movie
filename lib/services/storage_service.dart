import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class StorageService {
  static const _favoriteKey = 'favorite_movies';
  static const _themeKey = 'dark_mode';

  Future<void> saveFavorites(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final list = movies.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList(_favoriteKey, list);
  }

  Future<List<Movie>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoriteKey) ?? [];
    return list.map((e) => Movie.fromStorage(json.decode(e))).toList();
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
}
