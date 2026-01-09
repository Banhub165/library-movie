/// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';
import 'movie_detail_page.dart';
import 'favorite_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [
          // 🌗 Theme toggle
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),

          // ❤️ Favorite Page
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              );
            },
          ),

          // 🔄 Refresh movies
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MovieProvider>().fetchMovies();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🌍 Location info
          Padding(
            padding: const EdgeInsets.all(12),
            child: locationProvider.loading
                ? const Text('Detecting location...')
                : Text('📍 Region: ${locationProvider.country ?? "Unknown"}'),
          ),

          // 🎬 Movie list
          Expanded(child: _buildMovieList(movieProvider)),
        ],
      ),
    );
  }

  Widget _buildMovieList(MovieProvider provider) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (provider.movies.isEmpty) {
      return const Center(child: Text('No movies found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: provider.movies.length,
      itemBuilder: (context, index) {
        final Movie movie = provider.movies[index];

        return MovieCard(
          movie: movie,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
            );
          },
        );
      },
    );
  }
}
