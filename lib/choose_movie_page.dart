import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'character_creation_page.dart';

class ChooseMoviePage extends StatefulWidget {
  @override
  _ChooseMoviePageState createState() => _ChooseMoviePageState();
}

class _ChooseMoviePageState extends State<ChooseMoviePage> {
  final TextEditingController _gameNameController = TextEditingController();
  int _currentMovieIndex = 0;

  final List<Map<String, String>> _movies = [
    {'name': 'Endgame', 'image': 'assets/images/endgame.png'},
    {'name': 'The Dark Knight', 'image': 'assets/images/dark_knight.jpg'},
    {'name': 'Interstellar', 'image': 'assets/images/interstellar.jpg'},
    {'name': 'The Matrix', 'image': 'assets/images/matrix.png'},
  ];

  final Color backgroundColor = const Color(0xFFE3EBE7); // Example background color
  final Color accentColor = const Color(0xFFE2543E); // Example accent color

  void _navigateToCharacterCreation() {
    final selectedMovie = _movies[_currentMovieIndex]['name']!;
    final gameName = _gameNameController.text;

    if (gameName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a game name.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterCreationPage(
          movieName: selectedMovie,
          chatName: gameName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text(
          'Choose a Movie',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: CarouselSlider.builder(
                  itemCount: _movies.length,
                  options: CarouselOptions(
                    height: 300.0,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentMovieIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final movie = _movies[index];
                    return MovieWidget(
                      movieName: movie['name']!,
                      imagePath: movie['image']!,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextField(
                controller: _gameNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter game name',
                  prefixIcon: Icon(Icons.edit_outlined),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 2,
                ),
                onPressed: _navigateToCharacterCreation,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue to Character Creation',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieWidget extends StatelessWidget {
  final String movieName;
  final String imagePath;

  const MovieWidget({Key? key, required this.movieName, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFE3EBE7); // Match app's background
    final accentColor = const Color(0xFFE2543E); // Match app's accent color

    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      color: backgroundColor.withOpacity(0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Movie image with gradient overlay
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Movie name
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                movieName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: accentColor, // Use app's accent color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


