import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';
import 'movie_detail_page.dart';
import 'favorite_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [
          // Toggle Light / Dark
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),

          // Favorite Page
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              );
            },
          ),

          // Refresh API
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              movieProvider.fetchMovies();
            },
          ),
        ],
      ),
      body: _buildBody(context, movieProvider),
    );
  }

  Widget _buildBody(BuildContext context, MovieProvider provider) {
    // 1️⃣ Loading
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2️⃣ Error
    if (provider.error != null) {
      return Center(
        child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    // 3️⃣ Empty
    if (provider.movies.isEmpty) {
      return const Center(child: Text('No movies found'));
    }

    // 4️⃣ Data Loaded
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
