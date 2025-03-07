import 'package:flutter/material.dart';

class SavedGame {
  final String movieName;
  final String chatName;
  final DateTime lastPlayed;
  final int progress;
  final String threadId;
  final int hp;
  final int sp;
  final int stepCount;
  final bool isAvailable;

  const SavedGame({
    required this.movieName,
    required this.chatName,
    required this.lastPlayed,
    required this.progress,
    required this.threadId,
    required this.hp,
    required this.sp,
    required this.stepCount,
    required this.isAvailable,
  });

  // Factory constructor to create an instance of SavedGame from a JSON map
  factory SavedGame.fromJson(Map<String, dynamic> json) {
    return SavedGame(
      movieName: json['movie_name'] ?? 'Unknown Movie', // Provide a default if missing
      chatName: json['chat_name'] ?? 'Unknown Chat',
      lastPlayed: DateTime.parse(json['updated_at']),
      progress: json['progress'] ?? 0,
      threadId: json['thread_id'],
      hp: json['hp'],
      sp: json['sp'],
      stepCount: json['step_count'],
      isAvailable: (json['progress'] >= 100) ? false : true
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