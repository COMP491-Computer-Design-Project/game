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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movieverse Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}


