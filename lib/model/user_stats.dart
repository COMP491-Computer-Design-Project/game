class UserStats {
  final String playerName;
  final int gameCount;
  final int maxScore;
  final int uniqueMovieCount;
  final int level;
  final double xp;

  UserStats({
    required this.playerName,
    required this.gameCount,
    required this.maxScore,
    required this.uniqueMovieCount,
    required this.level,
    required this.xp,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    print(json);
    return UserStats(
      playerName: json['username'] ?? 'Player',
      gameCount: json['num_games_played'] ?? 0,
      maxScore: json['highest_score'] ?? 0,
      uniqueMovieCount: json['num_movies_played'] ?? 0,
      level: json['level'] ?? 0,
      xp: json['total_score'] ?? 0.0,
    );
  }

  // Default stats for loading state
  factory UserStats.loading() {
    return UserStats(
      playerName: 'Loading...',
      gameCount: 0,
      maxScore: 0,
      uniqueMovieCount: 0,
      level: 1,
      xp: 1
    );
  }
}
