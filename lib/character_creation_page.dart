import 'package:flutter/material.dart';
import 'character_feature_info.dart';
import 'character_feature_widget.dart';
import 'game_page.dart';

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

  final List<CharacterFeatureInfo> characterFeatures = [
    CharacterFeatureInfo(
      name: "Güç",
      key: 'strength',
      image: "power.png",
      description: "Fiziksel kuvvet, dayanıklılık gerektiren eylemler.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Hız",
      key: 'speed',
      image: "speed.png",
      description: "Çeviklik ve hız.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Dayanıklılık",
      key: 'endurance',
      image: "stamina.png",
      description: "Zorluklara karşı direnç.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Refleks",
      key: 'reflexes',
      image: "reflex.png",
      description: "Ani olaylara hızlı tepki verme yeteneği.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Görüş",
      key: 'vision',
      image: "vision.png",
      description: "Keskin gözlem yeteneği.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Zeka",
      key: 'intelligence',
      image: "intelligence.png",
      description: "Bilmece çözmek, bilimsel ekipman kullanmak.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Strateji",
      key: 'strategy',
      image: "strategy.png",
      description: "Karmaşık olayları planlama ve çözme.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Karizma",
      key: 'charisma',
      image: "charisma.png",
      description: "İkna ve iletişim gücü.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Sezgi",
      key: 'intuition',
      image: "intuition.png",
      description: "Tehlikeyi önceden tahmin etme.",
      currentValue: 3.0,
    ),
    CharacterFeatureInfo(
      name: "Odaklanma",
      key: 'focus',
      image: "focus.png",
      description: "Zihinsel dayanıklılık.",
      currentValue: 3.0,
    ),
  ];

  void _updateFeatureValue(int index, double newValue) {
    final difference = newValue - characterFeatures[index].currentValue;

    if (difference <= remainingIncrements) {
      setState(() {
        remainingIncrements -= difference.toInt();
        characterFeatures[index].currentValue = newValue;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have only $remainingIncrements increments left!')),
      );
    }
  }

  Map<String, int> _generateCharacterValuesMap() {
    return {
      for (var feature in characterFeatures) feature.key: feature.currentValue.toInt()
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Character Creation'),
            Text(
              'Remaining Increments: $remainingIncrements',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: characterFeatures.length + 1,
        itemBuilder: (context, index) {
          if (index < characterFeatures.length) {
            final feature = characterFeatures[index];
            return CharacterFeatureWidget(
              feature: feature,
              onValueChanged: (value) => _updateFeatureValue(index, value),
            );
          } else {
            // This is the last item (the button)
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (remainingIncrements >= 0) {
                      final characterValues = _generateCharacterValuesMap();
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
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Use all increments before continuing!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Continue to Game',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
