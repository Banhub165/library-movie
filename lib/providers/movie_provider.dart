import 'package:flutter/material.dart';
import '../locator.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _api = locator<ApiService>();

  List<Movie> movies = [];
  bool loading = false;
  String? error;

  Future<void> fetchMovies() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      movies = await _api.fetchPopularMovies();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
