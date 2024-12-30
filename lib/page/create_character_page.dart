import 'package:flutter/material.dart';
import 'package:game/page/home_page.dart';
import 'package:game/theme/theme.dart';
import '../component/character_feature_widget.dart';
import 'game_page.dart';
import '../model/character_feature_info.dart';

class CharacterCreationPage extends StatefulWidget {
  final String movieName;
  final String movieId;

  const CharacterCreationPage({
    Key? key,
    required this.movieName,
    required this.movieId,
  }) : super(key: key);

  @override
  State<CharacterCreationPage> createState() => _CharacterCreationPageState();
}

class _CharacterCreationPageState extends State<CharacterCreationPage> {
  final int maxIncrements = 20;
  int remainingIncrements = 20;
  final TextEditingController _characterNameController =
      TextEditingController();
  final TextEditingController _chatNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    remainingIncrements = maxIncrements;
    _characterNameController.clear();
    _chatNameController.clear();
    for (var feature in characterFeatures) {
      feature.currentValue = feature.defaultValue; // Reset feature values
    }
  }

  void _cleanupAndExit() {
    setState(() {
      _initializeDefaults();
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

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
                      onTap: _cleanupAndExit,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
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
                          prefixIcon:
                              Icon(Icons.person_outline, color: Colors.white60),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingSmall,
                            vertical: AppTheme.paddingSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _chatNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter chat name',
                          hintStyle: TextStyle(color: Colors.white60),
                          prefixIcon:
                              Icon(Icons.person_outline, color: Colors.white60),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingSmall,
                            vertical: AppTheme.paddingSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    // Character Features
                    ...characterFeatures.map((feature) {
                      final index = characterFeatures.indexOf(feature);
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppTheme.paddingSmall),
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
                                Text('Start Adventure',
                                    style: AppTheme.buttonTextStyle),
                                const SizedBox(width: AppTheme.paddingSmall),
                                const Icon(Icons.play_arrow),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.paddingSmall),
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
    if (_chatNameController.text.isEmpty) {
      _showSnackBar('Please enter a chat name!');
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
          characterName: _characterNameController.text,
          movieName: widget.movieName,
          movieId: widget.movieId,
          chatName: _chatNameController.text,
          characterValues: characterValues,
          isNewGame: true,
        ),
      ),
    );
  }
}
