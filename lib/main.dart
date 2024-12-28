import 'package:flutter/material.dart';
import 'package:game/page/choose_movie_page.dart';
import 'package:game/page/create_character_page.dart';
import 'package:game/page/home_page.dart';
import 'package:game/page/leaderboard_page.dart';
import 'package:game/page/login_page.dart';
import 'package:game/page/profile_page.dart';
import 'package:game/page/quick_play_page.dart';
import 'package:game/page/register_page.dart';
import 'package:game/page/saved_games_page.dart';
import 'package:game/page/welcome_page.dart';
import 'package:game/provider/movie_data_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movieverse Explorer',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/game-home': (context) => const HomePage(),
        '/leaderboard': (context) => const LeaderboardPage(),
        '/profile': (context) => const ProfilePage(),
        '/choose-movie': (context) => const ChooseMoviePage(),
        '/quick-play': (context) => const QuickPlayPage(),
        '/saved-games': (context) => const SavedGamesPage(),
        '/character-creation-page': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CharacterCreationPage(
            movieName: args['movieName'],
            movieId: args['movieId'],
          );
        },
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}


