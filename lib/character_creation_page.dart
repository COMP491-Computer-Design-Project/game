import 'package:flutter/material.dart';
import 'package:game/component/animated_background.dart';
import 'package:game/theme/theme.dart';
import 'component/animated_progress_bar.dart';
import 'component/character_feature_widget.dart';
import 'game_page.dart';
import 'model/character_feature_info.dart';
import 'saved_characters_page.dart';

class CharacterCreationPage extends StatefulWidget {
  final String movieName;
  final String movieId;
  final String chatName;

  const CharacterCreationPage({
    Key? key,
    required this.movieName,
    required this.movieId,
    required this.chatName,
  }) : super(key: key);

  @override
  State<CharacterCreationPage> createState() => _CharacterCreationPageState();
}

class _CharacterCreationPageState extends State<CharacterCreationPage> {
  final int maxIncrements = 20;
  int remainingIncrements = 20;
  final TextEditingController _characterNameController = TextEditingController();

  void _updateFeatureValue(int index, double newValue) {
    final difference = newValue - characterFeatures[index].currentValue;
    if (difference <= remainingIncrements) {
      setState(() {
        remainingIncrements -= difference.toInt();
        characterFeatures[index].currentValue = newValue;
      });
    } else {
      _showSnackBar('You have only $remainingIncrements points left!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.accent.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Map<String, int> _generateCharacterValuesMap() {
    return {
      for (var feature in characterFeatures)
        feature.key: feature.currentValue.toInt()
    };
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
                      onTap: () {
                        Navigator.of(context).pop();
                      },
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
                        'Create Your Character',
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

              // Points Remaining Indicator
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingMedium,
                  vertical: AppTheme.paddingSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Skill Points Remaining',
                          style: AppTheme.bodyStyle,
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppTheme.accentGradient.createShader(bounds),
                          child: Text(
                            '$remainingIncrements',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              // Character Creation Form
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  children: [
                    // Character Name Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _characterNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter character name',
                          hintStyle: TextStyle(color: Colors.white60),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white60),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingSmall,
                            vertical: AppTheme.paddingSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),

                    // Load Saved Character Button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingMedium,
                        vertical: AppTheme.paddingSmall,
                      ),
                      child: ElevatedButton.icon(
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
                            MaterialPageRoute(builder: (context) => const SavedCharactersPage()),
                          );
                        },
                        icon: Icon(Icons.person_search, color: AppTheme.accent),
                        label: const Text(
                          'Load Saved Character',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Character Features
                    ...characterFeatures.map((feature) {
                      final index = characterFeatures.indexOf(feature);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
                        child: _buildFeatureCard(feature, index),
                      );
                    }).toList(),

                    const SizedBox(height: AppTheme.paddingMedium),

                    // Action Buttons
                    Column(
                      children: [
                        // Continue Button
                        Container(
                          decoration: AppTheme.buttonBoxDecoration,
                          child: ElevatedButton(
                            style: AppTheme.buttonStyle,
                            onPressed: _handleContinue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Start Adventure', style: AppTheme.buttonTextStyle),
                                const SizedBox(width: AppTheme.paddingSmall),
                                const Icon(Icons.play_arrow),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.paddingSmall),

                        // Save Character Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _handleSave,
                          child: const Text(
                            'Save Character',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(CharacterFeatureInfo feature, int index) {
    return CharacterFeatureWidget(
      feature: feature,
      onValueChanged: (value) => _updateFeatureValue(index, value),
    );
  }

  void _handleContinue() {
    if (_characterNameController.text.isEmpty) {
      _showSnackBar('Please enter a character name!');
      return;
    }
    if (remainingIncrements > 0) {
      _showSnackBar('Use all skill points before continuing!');
      return;
    }
    
    final characterValues = _generateCharacterValuesMap();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          movieName: widget.movieName,
          movieId: widget.movieId,
          chatName: widget.chatName,
          characterValues: characterValues,
        ),
      ),
    );
  }

  void _handleSave() {
    if (_characterNameController.text.isEmpty) {
      _showSnackBar('Please enter a character name before saving!');
      return;
    }
    // Implement save functionality
    _showSnackBar('Character saved successfully!');
  }
}
