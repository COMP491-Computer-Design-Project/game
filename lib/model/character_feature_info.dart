class CharacterFeatureInfo {
  final String name;
  final String key;
  final String image;
  final String description;
  double currentValue;

  CharacterFeatureInfo({
    required this.name,
    required this.key,
    required this.image,
    required this.description,
    required this.currentValue,
  });
}

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
