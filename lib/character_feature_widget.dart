import 'package:flutter/material.dart';
import 'character_feature_info.dart';

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

            // Feature Description
            Text(
              widget.feature.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Slider
            Row(
              children: [
                Text(_currentValue.toInt().toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
