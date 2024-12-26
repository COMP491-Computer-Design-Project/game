import 'package:flutter/material.dart';

class SavedGame {
  final String movieName;
  final String chatName;
  final String lastPlayed;
  final int progress;

  const SavedGame({
    required this.movieName,
    required this.chatName,
    required this.lastPlayed,
    required this.progress,
  });

  IconData getMovieIcon() {
    switch (movieName) {
      case 'The Dark Knight':
        return Icons.dark_mode;
      case 'Avengers: Endgame':
        return Icons.shield;
      case 'Interstellar':
        return Icons.rocket;
      case 'The Matrix':
        return Icons.computer;
      default:
        return Icons.movie;
    }
  }
}