import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:game/page/create_character_page.dart';
import 'package:game/client/api_client.dart';
import 'package:game/model/movie_data.dart';
import 'package:game/theme/theme.dart';

class QuickPlayPage extends StatefulWidget {
  const QuickPlayPage({Key? key}) : super(key: key);

  @override
  _QuickPlayPageState createState() => _QuickPlayPageState();
}

class _QuickPlayPageState extends State<QuickPlayPage> {
  final ApiClient _apiClient = ApiClient();

  List<MovieData> movies = [];

  /// The final movie shown to the user AFTER spinning finishes
  MovieData? selectedMovie;

  /// A temporary movie to hold our random pick while spinning
  MovieData? _upcomingMovie;

  bool isSpinning = false;
  final ScrollController _scrollController = ScrollController();

  static const double _itemHeight = 90;
  static const double _itemVerticalMargin = 8; // top + bottom = 16
  static const double _containerHeight = 300;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  /// Fetch list of movies from the API
  Future<void> _fetchMovies() async {
    try {
      final fetchedMovies = await _apiClient.getMovies();
      setState(() {
        movies = fetchedMovies;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load movies: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _spinWheel() {
    // Don’t spin if already spinning or if we have no movies
    if (isSpinning || movies.isEmpty) return;

    setState(() => isSpinning = true);

    // 1) Pick a random movie
    final randomIndex = Random().nextInt(movies.length);
    _upcomingMovie = movies[randomIndex];

    // 2) Calculate the scroll offset that centers this item.
    //    Each item is 90px high plus 16px vertical margin = 106 total.
    //    So itemExtent = 106. We also want multiple spins, so we add
    //    (movies.length * spinCount). Then subtract half the difference
    //    between container height and itemExtent to land in the center.
    final double itemExtent = _itemHeight + _itemVerticalMargin * 2; // 106
    final spinCount = 5;
    final double baseIndex = (randomIndex + (movies.length * spinCount)).toDouble();

    final double targetOffset =
        itemExtent * baseIndex - ((_containerHeight - itemExtent) / 2);

    // 3) Animate the scroll
    _scrollController
        .animateTo(
      targetOffset,
      duration: const Duration(seconds: 3),
      curve: Curves.easeOutCubic,
    )
        .then((_) {
      // Now the wheel is stopped at our chosen movie
      setState(() {
        selectedMovie = _upcomingMovie;
        isSpinning = false;
      });

      // OPTIONAL: Navigate to next screen or wait a bit
      Future.delayed(const Duration(seconds: 1), () {
        _navigateToCharacterCreation();
      });
    });
  }

  void _navigateToCharacterCreation() {
    if (selectedMovie == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterCreationPage(
          movieId: selectedMovie!.name,
          movieName: selectedMovie!.title,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Main build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: AppTheme.paddingMedium),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.accentGradient.createShader(bounds),
                      child: const Text(
                        'Quick Play',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Show the movie name ONLY after spinning is done
              if (selectedMovie != null && !isSpinning)
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
                  child: Text(
                    'Selected: ${selectedMovie!.title}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              /// Main Area
              Expanded(
                child: movies.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.accent),
                      ),
                      const SizedBox(height: AppTheme.paddingMedium),
                      Text(
                        'Loading movies...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// The “Wheel” Container
                      Container(
                        height: _containerHeight, // 300
                        width: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.75),
                              Colors.black.withOpacity(0.55),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppTheme.accent, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accent.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Stack(
                            children: [
                              /// Infinite-like scrolling list
                              ListView.builder(
                                controller: _scrollController,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: movies.length * 10,
                                itemBuilder: (context, index) {
                                  final movie = movies[index % movies.length];
                                  return Container(
                                    height: _itemHeight, // 90
                                    margin: const EdgeInsets.symmetric(
                                      vertical: _itemVerticalMargin, // 8
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image:
                                        NetworkImage(movie.imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.black.withOpacity(0.3),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              /// Top Gradient Fade
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              /// Bottom Gradient Fade
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// The Highlight in the Center
                              IgnorePointer(
                                child: Center(
                                  child: Container(
                                    height: _itemHeight,
                                    decoration: BoxDecoration(
                                      border: Border.symmetric(
                                        horizontal: BorderSide(
                                          color: AppTheme.accent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppTheme.paddingLarge),

                      /// SPIN Button
                      ElevatedButton(
                        onPressed: isSpinning ? null : _spinWheel,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          backgroundColor: AppTheme.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: AppTheme.accent.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSpinning ? Icons.refresh : Icons.casino,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppTheme.paddingSmall),
                            Text(
                              isSpinning ? 'Spinning...' : 'Spin the Wheel!',
                              style: isSpinning ? const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                  color: Colors.white
                              ) : const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
