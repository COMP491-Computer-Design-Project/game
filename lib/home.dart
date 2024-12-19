import 'package:flutter/material.dart';
import 'package:game/character_creation_page.dart';
import 'package:game/choose_movie_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFFE2543E); // Adjust as needed

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseMoviePage()));
            },
            child: const Text(
              'Start Game',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
