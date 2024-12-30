import 'package:flutter/material.dart';
import 'package:game/page/choose_movie_page.dart';
import 'package:game/page/leaderboard_page.dart';
import 'package:game/page/postgame_page.dart';
import 'package:game/page/profile_page.dart';
import 'package:game/page/quick_play_page.dart';
import 'package:game/page/saved_games_page.dart';
import 'package:game/theme/theme.dart';
import 'package:game/model/user_stats.dart';
import 'package:game/client/api_client.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiClient = ApiClient();
  late Future<UserStats> userStatsFuture;

  @override
  void initState() {
    super.initState();
    userStatsFuture = _fetchUserStats();
  }

  Future<UserStats> _fetchUserStats() async {
    try {
      return await apiClient.getHomePageStats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load stats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Return dummy data if API call fails
      return UserStats(
        playerName: 'Guest Player',
        gameCount: 0,
        maxScore: 0,
        uniqueMovieCount: 0,
        level: 1,
        xp: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: FutureBuilder<UserStats>(
            future: userStatsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Use dummy data if there's an error
              final userStats = snapshot.data ?? UserStats(
                playerName: 'Guest Player',
                gameCount: 0,
                maxScore: 0,
                uniqueMovieCount: 0,
                level: 1,
                xp: 0,
              );
              
              return Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  children: [
                    // Header with logo and player info
                    Row(
                      children: [
                        // Player Avatar
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.accent,
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white24,
                            backgroundImage:
                                AssetImage('assets/images/avatar_placeholder.png'),
                          ),
                        ),
                        const SizedBox(width: AppTheme.paddingSmall),
                        // Player Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userStats.playerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  gradient: AppTheme.accentGradient,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Settings/Profile Button
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilePage()),
                              );
                            },
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingMedium,
                        vertical: AppTheme.paddingSmall,
                      ),
                      padding: const EdgeInsets.all(AppTheme.paddingSmall),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.accentGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.military_tech,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: AppTheme.paddingSmall),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Current Level',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Level ${userStats.level}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${userStats.xp.toInt()} XP',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Game Stats Cards
                    Row(
                      children: [
                        _buildStatCard('Games\nPlayed', userStats.gameCount.toString(), Icons.games),
                        const SizedBox(width: AppTheme.paddingSmall),
                        _buildStatCard('Highest\nScore', userStats.maxScore.toString(), Icons.star),
                        const SizedBox(width: AppTheme.paddingSmall),
                        _buildStatCard(
                            'Movies\nPlayed', userStats.uniqueMovieCount.toString(), Icons.movie_filter_outlined),
                      ],
                    ),
                    const SizedBox(height: AppTheme.paddingLarge),

                    // Game Modes Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppTheme.accentGradient.createShader(bounds),
                            child: const Text(
                              'Choose Your Adventure',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.paddingMedium),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: AppTheme.paddingSmall,
                              crossAxisSpacing: AppTheme.paddingSmall,
                              children: [
                                _buildGameModeCard(
                                  'Story Mode',
                                  Icons.movie,
                                  'Embark on an epic movie journey',
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChooseMoviePage()),
                                  )
                                ),
                                _buildGameModeCard(
                                  'Quick Play',
                                  Icons.flash_on,
                                  'Jump into random scenarios',
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => QuickPlayPage()),
                                      ),
                                ),
                                _buildGameModeCard(
                                  'Continue Game',
                                  Icons.save,
                                  'Resume your last adventure',
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SavedGamesPage()),
                                  ),
                                ),
                                _buildGameModeCard(
                                  'Leaderboard',
                                  Icons.emoji_events,
                                  'See your global ranking',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LeaderboardPage()
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.paddingSmall),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white24,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.accent, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeCard(
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white24,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              decoration: const BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
                gradient: AppTheme.accentGradient,
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: AppTheme.paddingSmall),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
