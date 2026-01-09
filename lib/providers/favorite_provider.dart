import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoriteProvider extends ChangeNotifier {
  static const _key = 'favorite_movies';

  List<Movie> _favorites = [];
  List<Movie> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      _favorites = decoded
          .map((e) => Movie.fromStorage(e as Map<String, dynamic>))
          .toList();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();

    final exists = _favorites.any((m) => m.id == movie.id);

    if (exists) {
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      _favorites.add(movie);
    }

    final jsonList = _favorites.map((m) => m.toJson()).toList();
    await prefs.setString(_key, json.encode(jsonList));

    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favorites.any((m) => m.id == movieId);
  }
}
