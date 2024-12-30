import 'package:flutter/material.dart';
import 'package:game/page/game_page.dart';
import 'package:game/theme/theme.dart';
import 'package:game/client/api_client.dart';
import 'package:intl/intl.dart';
import '../model/saved_game.dart';
import 'create_character_page.dart';

class SavedGamesPage extends StatefulWidget {
  const SavedGamesPage({Key? key}) : super(key: key);

  @override
  State<SavedGamesPage> createState() => _SavedGamesPageState();
}

class _SavedGamesPageState extends State<SavedGamesPage> {
  List<SavedGame> _savedGames = [];
  bool _isLoading = true;
  final apiClient = ApiClient();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');


  @override
  void initState() {
    super.initState();
    _loadSavedGames();
  }

  Future<void> _loadSavedGames() async {
    try {
      final chats = await apiClient.getUserChats();
      setState(() {
        _savedGames = chats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // You might want to show an error message here
    }
  }

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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _savedGames.isEmpty
                        ? const Center(
                            child: Text(
                              'No saved games found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppTheme.paddingMedium),
                            itemCount: _savedGames.length,
                            itemBuilder: (context, index) {
                              final game = _savedGames[index];
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GamePage(movieName: game.movieName, chatName: game.chatName, threadId: game.threadId, isNewGame: false, hp: game.hp, sp: game.sp,)),
          );
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
                          'Last played: ${formatter.format(game.lastPlayed)}',
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

