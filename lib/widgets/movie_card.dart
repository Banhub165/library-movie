import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final Widget? trailing; // ✅ TAMBAHAN

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.trailing, // ✅ TAMBAHAN
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: movie.posterPath.isNotEmpty
            ? Image.network(
                'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                width: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.movie),
        title: Text(movie.title),
        subtitle: Text('⭐ ${movie.rating}', maxLines: 1),
        trailing: trailing, // ✅ DIPAKAI DI SINI
        onTap: onTap,
      ),
    );
  }
}
