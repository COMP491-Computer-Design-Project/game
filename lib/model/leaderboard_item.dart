class Leaderboard {
  final List<LeaderboardItem> leaderboard;

  Leaderboard({
    required this.leaderboard,
  });

  factory Leaderboard.fromJson(List<dynamic> json) {
    var list = json as List;
    List<LeaderboardItem> leaderboardList = list.map((i) => LeaderboardItem.fromJson(i)).toList();
    return Leaderboard(leaderboard: leaderboardList);
  }

}

class LeaderboardItem {
  final String username;
  final double totalScore;
  final int level;

  LeaderboardItem({
    required this.username,
    required this.totalScore,
    required this.level,
  });

  factory LeaderboardItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardItem(
      username: json['username'],
      totalScore: json['total_score'].toDouble(),
      level: json['level'],
    );
  }
}
