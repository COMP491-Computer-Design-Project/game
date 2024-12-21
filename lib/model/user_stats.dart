class UserStats {
  final String playerName;
  final int gameCount;
  final int maxScore;
  final int currentStreak;

  UserStats({
    required this.playerName,
    required this.gameCount,
    required this.maxScore,
    required this.currentStreak,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      playerName: json['player_name'] ?? 'Player',
      gameCount: json['game_count'] ?? 0,
      maxScore: json['max_score'] ?? 0,
      currentStreak: json['current_streak'] ?? 0,
    );
  }

  // Default stats for loading state
  factory UserStats.loading() {
    return UserStats(
      playerName: 'Loading...',
      gameCount: 0,
      maxScore: 0,
      currentStreak: 0,
    );
  }
}
