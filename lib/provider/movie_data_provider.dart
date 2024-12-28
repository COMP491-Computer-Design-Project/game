import 'package:flutter/material.dart';
import 'package:game/model/movie_data.dart';

class MovieDataProvider with ChangeNotifier {
  List<MovieData> _movies = [];

  List<MovieData> get movies => _movies;

  void setMovies(List<MovieData> movies) {
    _movies = movies;
    notifyListeners(); // Notify widgets about the data update
  }
}
