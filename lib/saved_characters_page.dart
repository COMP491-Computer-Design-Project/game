import 'package:flutter/material.dart';
import 'package:game/theme/theme.dart';
import 'package:game/model/character_feature_info.dart';

class SavedCharactersPage extends StatelessWidget {
  const SavedCharactersPage({Key? key}) : super(key: key);

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
                        'Saved Characters',
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
                      hintText: 'Search characters...',
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

              // Characters List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  itemCount: savedCharacters.length,
                  itemBuilder: (context, index) {
                    final character = savedCharacters[index];
                    return _buildCharacterCard(context, character);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, SavedCharacter character) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Return the selected character to the creation page
          Navigator.pop(context, character);
        },
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: AppTheme.paddingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Created: ${character.createdDate}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              Wrap(
                spacing: AppTheme.paddingSmall,
                runSpacing: AppTheme.paddingSmall,
                children: character.topStats.entries.map((stat) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getStatIcon(stat.key),
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${stat.key}: ${stat.value}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getStatIcon(String stat) {
    switch (stat.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'speed':
        return Icons.speed;
      case 'intelligence':
        return Icons.psychology;
      default:
        return Icons.star;
    }
  }
}

class SavedCharacter {
  final String name;
  final String createdDate;
  final int level;
  final Map<String, int> topStats;
  final Map<String, int> allStats;

  const SavedCharacter({
    required this.name,
    required this.createdDate,
    required this.level,
    required this.topStats,
    required this.allStats,
  });
}

// Placeholder saved characters data
final List<SavedCharacter> savedCharacters = [
  SavedCharacter(
    name: 'Batman',
    createdDate: '2024-03-15',
    level: 8,
    topStats: {
      'Strength': 8,
      'Intelligence': 9,
      'Speed': 7,
    },
    allStats: {
      'strength': 8,
      'intelligence': 9,
      'speed': 7,
      'endurance': 8,
      'reflexes': 9,
      'vision': 7,
      'strategy': 9,
      'charisma': 6,
      'intuition': 8,
      'focus': 9,
    },
  ),
  SavedCharacter(
    name: 'Iron Man',
    createdDate: '2024-03-14',
    level: 10,
    topStats: {
      'Intelligence': 10,
      'Strategy': 9,
      'Focus': 8,
    },
    allStats: {
      'strength': 7,
      'intelligence': 10,
      'speed': 8,
      'endurance': 7,
      'reflexes': 8,
      'vision': 8,
      'strategy': 9,
      'charisma': 8,
      'intuition': 7,
      'focus': 8,
    },
  ),
  SavedCharacter(
    name: 'Cooper',
    createdDate: '2024-03-13',
    level: 7,
    topStats: {
      'Intelligence': 8,
      'Focus': 9,
      'Strategy': 8,
    },
    allStats: {
      'strength': 6,
      'intelligence': 8,
      'speed': 7,
      'endurance': 7,
      'reflexes': 7,
      'vision': 8,
      'strategy': 8,
      'charisma': 7,
      'intuition': 8,
      'focus': 9,
    },
  ),
  SavedCharacter(
    name: 'Neo',
    createdDate: '2024-03-12',
    level: 9,
    topStats: {
      'Speed': 10,
      'Reflexes': 10,
      'Focus': 9,
    },
    allStats: {
      'strength': 8,
      'intelligence': 8,
      'speed': 10,
      'endurance': 8,
      'reflexes': 10,
      'vision': 8,
      'strategy': 7,
      'charisma': 7,
      'intuition': 8,
      'focus': 9,
    },
  ),
]; 