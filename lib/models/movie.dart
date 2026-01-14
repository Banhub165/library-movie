/// lib/models/movie.dart
class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;

  // RATING DARI API (ASLI)
  final double rating;

  // STATUS WATCHED
  bool watched;

  // USER RATING (0 - 10)
  double userRating;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    this.watched = false,
    this.userRating = 0.0,
  });

  // FINAL RATING (85% API + 15% USER)
  double get finalRating {
    return (rating * 0.85) + (userRating * 0.15);
  }

  // Dari TMDB API
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      watched: false, // default dari API
      userRating: 0.0, // default user belum rating
    );
  }

  // Untuk disimpan ke local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': rating,
      'watched': watched,
      'user_rating': userRating,
    };
  }

  // Dari local storage
  factory Movie.fromStorage(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      rating: (json['vote_average'] ?? 0).toDouble(),
      watched: json['watched'] ?? false,
      userRating: (json['user_rating'] ?? 0).toDouble(),
    );
  }
}
