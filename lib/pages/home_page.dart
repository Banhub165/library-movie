import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/location_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';

import '../widgets/movie_card.dart';
import '../widgets/movie_carousel_card.dart';
import '../models/movie.dart';

import 'movie_detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LocationProvider>().fetchLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    final isDark = themeProvider.isDark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? const [
                      Color(0xFFB71C1C), // dark red
                      Color(0xFFEF6C00), // orange
                      Color(0xFF0E0E0E),
                    ]
                  : const [
                      Color(0xFFFFF3E0), // light orange
                      Color(0xFFFFCDD2), // light red
                      Color(0xFFFFFFFF),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'My Movie Mine',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MovieProvider>().fetchMovies();
              context.read<LocationProvider>().fetchLocation();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          // ================= REGION BADGE =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: locationProvider.loading
                ? Row(
                    children: const [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Detecting region...'),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          locationProvider.country,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // ================= TRENDING =================
          _buildTrendingCarousel(movieProvider, isDark),

          const SizedBox(height: 12),

          // ================= MOVIE LIST =================
          _buildMovieList(movieProvider, favoriteProvider),
        ],
      ),
    );
  }

  // ================= TRENDING CAROUSEL =================
  Widget _buildTrendingCarousel(MovieProvider provider, bool isDark) {
    if (provider.loading) {
      return const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.movies.isEmpty) return const SizedBox();

    final featured = provider.movies
        .where((m) => m.rating >= 7.0)
        .take(10)
        .toList();

    if (featured.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '🔥 Trending Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final movie = featured[index];
              return MovieCarouselCard(
                movie: movie,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= MOVIE LIST =================
  Widget _buildMovieList(
    MovieProvider provider,
    FavoriteProvider favoriteProvider,
  ) {
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: provider.movies.length,
      itemBuilder: (context, index) {
        final Movie movie = provider.movies[index];
        final isFavorite = favoriteProvider.isFavorite(movie.id);

        return MovieCard(
          movie: movie,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
            );
          },
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : Colors.grey,
            ),
            onPressed: () {
              favoriteProvider.toggleFavorite(movie);
            },
          ),
        );
      },
    );
  }
}
