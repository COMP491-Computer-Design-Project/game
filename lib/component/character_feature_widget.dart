import 'package:flutter/material.dart';
import '../model/character_feature_info.dart';

class CharacterFeatureWidget extends StatefulWidget {
  final CharacterFeatureInfo feature;
  final ValueChanged<double>? onValueChanged;

  const CharacterFeatureWidget({
    Key? key,
    required this.feature,
    this.onValueChanged,
  }) : super(key: key);

  @override
  State<CharacterFeatureWidget> createState() => _CharacterFeatureWidgetState();
}

class _CharacterFeatureWidgetState extends State<CharacterFeatureWidget> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.feature.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature Name
            Text(
              widget.feature.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.feature.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Slider with custom theme
            Row(
              children: [
                Text(
                  _currentValue.toInt().toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFE2543E), // Accent color
                      inactiveTrackColor: const Color(0xFFE3EBE7), // Background color
                      thumbColor: const Color(0xFFE2543E), // Accent color
                      overlayColor: const Color(0xFFE2543E).withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                      trackHeight: 4.0,
                    ),
                    child: Slider(
                      value: _currentValue,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _currentValue.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          _currentValue = value;
                        });
                        widget.onValueChanged?.call(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
