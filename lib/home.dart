import 'package:flutter/material.dart';
import 'package:game/character_creation_page.dart';
import 'package:game/choose_movie_page.dart';
import 'package:game/saved_games_page.dart';
import 'package:game/theme/theme.dart';
import 'package:game/model/user_stats.dart';
import 'package:game/client/api_client.dart';
import 'package:game/leaderboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiClient = ApiClient();
  UserStats? userStats;

  @override
  void initState() {
    super.initState();
    _fetchUserStats();
  }

  Future<void> _fetchUserStats() async {
    try {
      final stats = await apiClient.getHomePageStats();
      setState(() {
        userStats = stats;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load stats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
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
                          const Text(
                            'Player One',
                            style: TextStyle(
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
                    // Settings Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Level',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Level 15',
                                style: TextStyle(
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
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '2,450 XP',
                              style: TextStyle(
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
                    _buildStatCard('Games\nPlayed', '12', Icons.games),
                    const SizedBox(width: AppTheme.paddingSmall),
                    _buildStatCard('High\nScore', '2850', Icons.star),
                    const SizedBox(width: AppTheme.paddingSmall),
                    _buildStatCard(
                        'Current\nStreak', '3', Icons.local_fire_department),
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
                                MaterialPageRoute(
                                  builder: (context) => const ChooseMoviePage(),
                                ),
                              ),
                            ),
                            _buildGameModeCard(
                              'Quick Play',
                              Icons.flash_on,
                              'Jump into random scenarios',
                              () {},
                            ),
                            _buildGameModeCard(
                              'Continue Game',
                              Icons.save,
                              'Resume your last adventure',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SavedGamesPage(),
                                ),
                              ),
                            ),
                            _buildGameModeCard(
                              'Multiplayer',
                              Icons.group,
                              'Play with friends',
                              () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppTheme.accent),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LeaderboardPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events, color: AppTheme.accent),
                        const SizedBox(width: AppTheme.paddingSmall),
                        const Text(
                          'Global Leaderboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
              decoration: BoxDecoration(
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

  Widget _buildStatCards() {
    final stats = userStats ?? UserStats.loading();

    return Row(
      children: [
        _buildStatCard(
          'Games\nPlayed',
          stats.gameCount.toString(),
          Icons.games,
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        _buildStatCard(
          'High\nScore',
          stats.maxScore.toString(),
          Icons.star,
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        _buildStatCard(
          'Current\nStreak',
          stats.currentStreak.toString(),
          Icons.local_fire_department,
        ),
      ],
    );
  }

  Widget _buildPlayerInfo() {
    final stats = userStats ?? UserStats.loading();

    return Row(
      children: [
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
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: AppTheme.paddingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stats.playerName,
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
      ],
    );
  }
}
