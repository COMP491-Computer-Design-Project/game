class MovieData {
  final int id;
  final String title;
  final String description;
  final String imagePath;
  final String genre;
  final double rating;
  final String name;

  MovieData({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.genre,
    required this.rating,
    required this.name,
  });

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      genre: json['genre'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
    );
  }

  static List<MovieData> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .cast<Map<String, dynamic>>()
        .map((json) => MovieData.fromJson(json))
        .toList();
  }
}