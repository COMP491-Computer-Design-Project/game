import 'package:flutter/material.dart';

class CharacterFeatureInfo {
  final String name;
  final String key;
  final String image;
  final String description;
  final IconData icon;
  double currentValue;
  double defaultValue;

  CharacterFeatureInfo({
    required this.name,
    required this.key,
    required this.image,
    required this.description,
    required this.icon,
    required this.currentValue,
    required this.defaultValue,
  });
}

final List<CharacterFeatureInfo> characterFeatures = [
  CharacterFeatureInfo(
    name: "Strength",
    key: 'strength',
    image: "power.png",
    description: "Physical power and ability to perform feats of strength",
    icon: Icons.fitness_center,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Speed",
    key: 'speed',
    image: "speed.png",
    description: "Agility and movement capabilities",
    icon: Icons.speed,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Endurance",
    key: 'endurance',
    image: "stamina.png",
    description: "Ability to withstand physical stress and fatigue",
    icon: Icons.battery_charging_full,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Reflexes",
    key: 'reflexes',
    image: "reflex.png",
    description: "Quick reaction time and combat awareness",
    icon: Icons.flash_on,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Vision",
    key: 'vision',
    image: "vision.png",
    description: "Perception and attention to detail",
    icon: Icons.visibility,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Intelligence",
    key: 'intelligence',
    image: "intelligence.png",
    description: "Problem-solving and analytical thinking",
    icon: Icons.psychology,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Strategy",
    key: 'strategy',
    image: "strategy.png",
    description: "Tactical planning and decision making",
    icon: Icons.architecture,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Charisma",
    key: 'charisma',
    image: "charisma.png",
    description: "Social influence and leadership ability",
    icon: Icons.record_voice_over,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Intuition",
    key: 'intuition',
    image: "intuition.png",
    description: "Gut feeling and ability to sense danger",
    icon: Icons.lightbulb,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
  CharacterFeatureInfo(
    name: "Focus",
    key: 'focus',
    image: "focus.png",
    description: "Mental concentration and willpower",
    icon: Icons.center_focus_strong,
    currentValue: 3.0,
    defaultValue: 3.0
  ),
];
