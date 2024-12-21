import 'package:flutter/material.dart';
import 'package:game/theme/theme.dart';
import 'package:game/game_page.dart';

class SavedGamesPage extends StatelessWidget {
  const SavedGamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
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
                        'Saved Games',
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

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingMedium,
                  vertical: AppTheme.paddingSmall,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search saved games...',
                      hintStyle: TextStyle(color: Colors.white60),
                      prefixIcon: Icon(Icons.search, color: Colors.white60),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingSmall,
                        vertical: AppTheme.paddingSmall,
                      ),
                    ),
                  ),
                ),
              ),

              // Saved Games List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  itemCount: savedGames.length,
                  itemBuilder: (context, index) {
                    final game = savedGames[index];
                    return _buildSavedGameCard(context, game);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedGameCard(BuildContext context, SavedGame game) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: InkWell(
        onTap: () {
        },
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      game.getMovieIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppTheme.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.movieName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Last played: ${game.lastPlayed}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Progress: ${game.progress}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingSmall),
              LinearProgressIndicator(
                value: game.progress / 100,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavedGame {
  final String movieName;
  final String chatName;
  final String lastPlayed;
  final int progress;
  final Map<String, int> characterValues;

  const SavedGame({
    required this.movieName,
    required this.chatName,
    required this.lastPlayed,
    required this.progress,
    required this.characterValues,
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

// Placeholder saved games data
final List<SavedGame> savedGames = [
  SavedGame(
    movieName: 'The Dark Knight',
    chatName: 'dark_knight',
    lastPlayed: '2 hours ago',
    progress: 75,
    characterValues: {'strength': 7, 'intelligence': 8, 'speed': 6},
  ),
  SavedGame(
    movieName: 'Interstellar',
    chatName: 'interstellar',
    lastPlayed: 'Yesterday',
    progress: 45,
    characterValues: {'intelligence': 9, 'endurance': 7, 'focus': 8},
  ),
  SavedGame(
    movieName: 'The Matrix',
    chatName: 'matrix',
    lastPlayed: '3 days ago',
    progress: 90,
    characterValues: {'reflexes': 9, 'intelligence': 8, 'speed': 8},
  ),
  SavedGame(
    movieName: 'Avengers: Endgame',
    chatName: 'endgame',
    lastPlayed: 'Last week',
    progress: 30,
    characterValues: {'strength': 8, 'strategy': 7, 'charisma': 6},
  ),
]; 