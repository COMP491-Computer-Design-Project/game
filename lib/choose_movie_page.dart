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
      appBar: AppBar(
        title: Text('Choose a Movie'),
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
                    height: 300.0, // Adjust the height for the images
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
            SizedBox(height: 16.0),
            TextField(
              controller: _gameNameController,
              decoration: InputDecoration(
                labelText: 'Enter game name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _navigateToCharacterCreation,
              child: Text('Continue to Character Creation'),
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
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Image.asset(
              imagePath,
              height: 200.0, // Adjust height of the image
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movieName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
