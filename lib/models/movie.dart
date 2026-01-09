/// lib/models/movie.dart
class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
  });

  // 🔹 Dari TMDB API
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  // 🔹 Untuk disimpan ke local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': rating,
    };
  }

  factory Movie.fromStorage(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      rating: (json['vote_average'] ?? 0).toDouble(),
    );
  }
}
