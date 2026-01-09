import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'providers/movie_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/location_provider.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (_) => MovieProvider()..fetchMovies()),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider()..loadFavorites(),
        ),
        ChangeNotifierProvider(
          create: (_) => locator<LocationProvider>()..fetchLocation(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie Library',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.red,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.red,
            ),
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
