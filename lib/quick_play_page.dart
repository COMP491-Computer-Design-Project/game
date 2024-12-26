import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game/character_creation_page.dart';
import 'package:game/choose_movie_page.dart';
import 'package:game/client/api_client.dart';
import 'package:game/model/movie_data.dart';
import 'package:game/theme/theme.dart';

class QuickPlayPage extends StatefulWidget {
  const QuickPlayPage({Key? key}) : super(key: key);

  @override
  _QuickPlayPageState createState() => _QuickPlayPageState();
}

class _QuickPlayPageState extends State<QuickPlayPage>
    with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();
  late AnimationController _controller;
  late Animation<double> _animation;
  List<MovieData> movies = [];
  MovieData? selectedMovie;
  bool isSpinning = false;
  final ScrollController _scrollController = ScrollController();
  String currentMovieTitle = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isSpinning = false;
        });
        _navigateToCharacterCreation();
      }
    });

    _fetchMovies();
  }

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
      final fetchedMovies = dummyMovieData;
      setState(() {
        movies = fetchedMovies;
      });
    }
  }

  void _spinWheel() {
    if (movies.isEmpty || isSpinning) return;

    setState(() {
      isSpinning = true;
      selectedMovie = movies[Random().nextInt(movies.length)];
    });

    final itemHeight = 90.0;
    final totalHeight = itemHeight * movies.length;
    final targetPosition = (Random().nextInt(movies.length) * itemHeight) + (totalHeight * 5);

    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(seconds: 3),
      curve: Curves.easeOutCubic,
    ).then((_) {
      setState(() {
        isSpinning = false;
      });
      Future.delayed(const Duration(seconds: 1), () {
        _navigateToCharacterCreation();
      });
    });
  }

  void _navigateToCharacterCreation() {
    if (selectedMovie == null) return;

    String chatName = 'randomgamechatname';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterCreationPage(movieId: selectedMovie!.movieId, movieName: selectedMovie!.title, chatName: chatName),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [

              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Selected Movie Display
              if (selectedMovie != null)
                Container(
                  margin: const EdgeInsets.all(AppTheme.paddingMedium),
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.movie_outlined, color: AppTheme.accent),
                      const SizedBox(width: AppTheme.paddingSmall),
                      Expanded(
                        child: Text(
                          selectedMovie?.title ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Slot Machine
              Expanded(
                child: movies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
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
                            Container(
                              height: 300,
                              width: 220,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.black.withOpacity(0.5),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.accent, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accent.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      controller: _scrollController,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: movies.length * 10,
                                      itemBuilder: (context, index) {
                                        final movie = movies[index % movies.length];
                                        return Container(
                                          height: 90,
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            image: DecorationImage(
                                              image: AssetImage(movie.imagePath),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.center,
                                          colors: [
                                            Colors.black.withOpacity(0.7),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.center,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.paddingLarge),
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
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
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