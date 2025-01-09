import 'package:flutter/material.dart';
import 'package:game/theme/theme.dart';
import 'package:game/client/api_client.dart';
import '../model/leaderboard_item.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

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
                        'Global Leaderboard',
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

              // Main content in Expanded widget
              Expanded(
                child: FutureBuilder<Leaderboard>(
                  future: ApiClient().getLeaderboard(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.leaderboard.isEmpty) {
                      return const Center(child: Text('No leaderboard data available'));
                    }

                    final leaderboard = snapshot.data!;
                    final hasTopThree = leaderboard.leaderboard.length >= 3;

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.paddingMedium),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasTopThree) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildTopPlayer(
                                    leaderboard.leaderboard[1].username,
                                    leaderboard.leaderboard[1].totalScore.toInt().toString(),
                                    2,
                                  ),
                                  _buildTopPlayer(
                                    leaderboard.leaderboard[0].username,
                                    leaderboard.leaderboard[0].totalScore.toInt().toString(),
                                    1,
                                  ),
                                  _buildTopPlayer(
                                    leaderboard.leaderboard[2].username,
                                    leaderboard.leaderboard[2].totalScore.toInt().toString(),
                                    3,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppTheme.paddingMedium),
                            ],

                            // Other players list
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: hasTopThree
                                  ? leaderboard.leaderboard.length - 3
                                  : leaderboard.leaderboard.length,
                              itemBuilder: (context, index) {
                                final itemIndex = hasTopThree ? index + 3 : index;
                                return _buildLeaderboardItem(
                                  itemIndex + 1,
                                  leaderboard.leaderboard[itemIndex],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopPlayer(String name, String score, int position) {
    final double height = position == 1 ? 160 : 130;
    final double avatarSize = position == 1 ? 80 : 60;
    final Color color = position == 1
        ? Colors.amber
        : position == 2
        ? Colors.grey[300]!
        : Colors.brown[300]!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: CircleAvatar(
            radius: avatarSize / 2,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: avatarSize / 2, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          score,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(0.5), color.withOpacity(0.2)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(int position, LeaderboardItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              position.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.paddingSmall),
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: AppTheme.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${item.totalScore.toInt()} points',
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
              'Level ${item.level}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}