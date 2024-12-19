import 'package:flutter/material.dart';
import 'package:game/component/animated_background.dart';
import 'component/animated_progress_bar.dart';
import 'component/character_feature_widget.dart';
import 'game_page.dart';
import 'model/character_feature_info.dart';

class CharacterCreationPage extends StatefulWidget {
  final String movieName;
  final String chatName;

  const CharacterCreationPage({
    Key? key,
    required this.movieName,
    required this.chatName,
  }) : super(key: key);

  @override
  State<CharacterCreationPage> createState() => _CharacterCreationPageState();
}

class _CharacterCreationPageState extends State<CharacterCreationPage> {
  final int maxIncrements = 30;
  int remainingIncrements = 30;
  final TextEditingController _characterNameController =
      TextEditingController();

  final Color backgroundColor = const Color(0xFFE3EBE7); // Match LoginPage
  final Color accentColor = const Color(0xFFE2543E); // Match LoginPage

  void _updateFeatureValue(int index, double newValue) {
    final difference = newValue - characterFeatures[index].currentValue;

    if (difference <= remainingIncrements) {
      setState(() {
        remainingIncrements -= difference.toInt();
        characterFeatures[index].currentValue = newValue;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('You have only $remainingIncrements increments left!')),
      );
    }
  }

  Map<String, int> _generateCharacterValuesMap() {
    return {
      for (var feature in characterFeatures)
        feature.key: feature.currentValue.toInt()
    };
  }

  void _saveCharacter() {
    if (_characterNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a character name before saving!')),
      );
      return;
    }

    final characterValues = _generateCharacterValuesMap();
    // Simulate saving the character locally or to a backend service.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Character saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AnimatedBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: accentColor,
            title: const Text(
              'Create your Character',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              // Progress bar at the top (always visible)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedProgressBar(
                  progress: (30 - remainingIncrements) / 30,
                  remaining: remainingIncrements,
                  color: accentColor,
                ),
              ),
              // Scrollable content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Character name input field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _characterNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a character name',
                          prefixIcon: Icon(Icons.person_outline),
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Features list
                    ...characterFeatures.map((feature) {
                      final index = characterFeatures.indexOf(feature);
                      return CharacterFeatureWidget(
                        feature: feature,
                        onValueChanged: (value) =>
                            _updateFeatureValue(index, value),
                      );
                    }).toList(),
                    const SizedBox(height: 16.0),
                    // "Continue to Game" button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (remainingIncrements >= 0 &&
                              _characterNameController.text.isNotEmpty) {
                            final characterValues =
                            _generateCharacterValuesMap();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GamePage(
                                  movieName: widget.movieName,
                                  chatName: widget.chatName,
                                  characterValues: characterValues,
                                ),
                              ),
                            );
                          } else if (_characterNameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter a character name!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Use all increments before continuing!')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text(
                          'Continue to game',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // "Save your character" button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveCharacter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          // A distinct color for the save button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text(
                          'Save your character',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
