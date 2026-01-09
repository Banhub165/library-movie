import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String _apiKey = '263df12663da30d82b2d747c31a86b08';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchPopularMovies() async {
    final uri = Uri.parse(
      '$_baseUrl/movie/popular'
      '?api_key=$_apiKey'
      '&language=en-US'
      '&page=1',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load movies (status: ${response.statusCode})');
    }
  }
}
