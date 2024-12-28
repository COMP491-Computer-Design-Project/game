import 'package:flutter/material.dart';

class SavedGame {
  final String movieName;
  final String chatName;
  final DateTime lastPlayed;
  final int progress;

  const SavedGame({
    required this.movieName,
    required this.chatName,
    required this.lastPlayed,
    required this.progress,
  });

  // Factory constructor to create an instance of SavedGame from a JSON map
  factory SavedGame.fromJson(Map<String, dynamic> json) {
    return SavedGame(
      movieName: json['movie_name'] ?? 'Unknown Movie', // Provide a default if missing
      chatName: json['chat_name'] ?? 'Unknown Chat',
      lastPlayed: DateTime.parse(json['updated_at']),
      progress: json['progress'] ?? 0,
    );
  }

  // Static method to create a list of SavedGame instances from a list of JSON maps
  static List<SavedGame> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => SavedGame.fromJson(json as Map<String, dynamic>))
        .toList();
  }


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