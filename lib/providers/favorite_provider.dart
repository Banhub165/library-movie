import 'package:flutter/material.dart';
import '../locator.dart';
import '../models/movie.dart';
import '../services/storage_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final StorageService _storage = locator<StorageService>();

  List<Movie> favorites = [];

  Future<void> loadFavorites() async {
    favorites = await _storage.loadFavorites();
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return favorites.any((m) => m.id == movie.id);
  }

  void toggleFavorite(Movie movie) {
    if (isFavorite(movie)) {
      favorites.removeWhere((m) => m.id == movie.id);
    } else {
      favorites.add(movie);
    }
    _storage.saveFavorites(favorites);
    notifyListeners();
  }
}
