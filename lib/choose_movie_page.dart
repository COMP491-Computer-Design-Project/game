import 'package:flutter/material.dart';
import 'package:game/character_creation_page.dart';
import 'package:game/theme/theme.dart';

class ChooseMoviePage extends StatefulWidget {
  const ChooseMoviePage({Key? key}) : super(key: key);

  @override
  _ChooseMoviePageState createState() => _ChooseMoviePageState();
}

class _ChooseMoviePageState extends State<ChooseMoviePage> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MovieData> get filteredMovies {
    return movieData.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          movie.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || movie.genre == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
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
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.paddingMedium),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.accentGradient.createShader(bounds),
                      child: const Text(
                        'Choose Your Story',
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
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search stories...',
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

              // Categories
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingMedium,
                  ),
                  children: [
                    _buildCategoryChip('All', selectedCategory == 'All'),
                    _buildCategoryChip('Action', selectedCategory == 'Action'),
                    _buildCategoryChip('Adventure', selectedCategory == 'Adventure'),
                    _buildCategoryChip('Drama', selectedCategory == 'Drama'),
                    _buildCategoryChip('Sci-Fi', selectedCategory == 'Sci-Fi'),
                  ],
                ),
              ),

              // Movie Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: AppTheme.paddingSmall,
                    mainAxisSpacing: AppTheme.paddingSmall,
                  ),
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    return _buildMovieCard(context, movie);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: AppTheme.paddingSmall),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.black45,
        selectedColor: AppTheme.accent,
        checkmarkColor: Colors.white,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              selectedCategory = label;
            });
          }
        },
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, MovieData movie) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterCreationPage(
            movieName: movie.title,
            movieId: movie.movieId,
            chatName: movie.movieId,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage(movie.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Movie Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        movie.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTag(movie.genre),
                        const Spacer(),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MovieData {
  final String title;
  final String description;
  final String imagePath;
  final String genre;
  final double rating;
  final String movieId;

  MovieData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.genre,
    required this.rating,
    required this.movieId,
  });
}

final List<MovieData> movieData = [
  MovieData(
    title: "The Dark Knight",
    description: "When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham. The Dark Knight must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
    imagePath: "assets/images/dark_knight.jpg",
    genre: "Action",
    rating: 4.9,
    movieId: "dark_knight",
  ),
  MovieData(
    title: "Avengers: Endgame",
    description: "After the devastating events of Avengers: Infinity War, the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos' actions and restore balance to the universe.",
    imagePath: "assets/images/endgame.png",
    genre: "Action",
    rating: 4.8,
    movieId: "Endgame",
  ),
  MovieData(
    title: "Interstellar",
    description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival. The film explores the themes of love, sacrifice, and the human spirit.",
    imagePath: "assets/images/interstellar.jpg",
    genre: "Sci-Fi",
    rating: 4.7,
    movieId: "interstellar",
  ),
  MovieData(
    title: "The Matrix",
    description: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers. The Matrix is a groundbreaking sci-fi film that explores themes of reality and perception.",
    imagePath: "assets/images/matrix.png",
    genre: "Sci-Fi",
    rating: 4.8,
    movieId: "matrix",
  ),
  MovieData(
    title: "Inception",
    description: "A skilled thief with the rare ability to steal secrets from people's minds during their dreams must plant an idea into a CEO's mind. A mind-bending journey through layers of dreams within dreams.",
    imagePath: "assets/images/inception.jpg",
    genre: "Sci-Fi",
    rating: 4.8,
    movieId: "inception",
  ),
  MovieData(
    title: "The Shawshank Redemption",
    description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency. A powerful story of hope and perseverance.",
    imagePath: "assets/images/shawshank.jpg",
    genre: "Drama",
    rating: 4.9,
    movieId: "shawshank",
  ),
];
