import 'package:flutter/material.dart';
import 'package:game/theme/theme.dart';
import 'package:game/model/character_feature_info.dart';

class CharacterFeatureWidget extends StatelessWidget {
  final CharacterFeatureInfo feature;
  final ValueChanged<double>? onValueChanged;

  const CharacterFeatureWidget({
    Key? key,
    required this.feature,
    this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(feature.icon, color: AppTheme.accent),
              const SizedBox(width: AppTheme.paddingSmall),
              Text(
                feature.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.accentGradient.createShader(bounds),
                child: Text(
                  feature.currentValue.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Text(
            feature.description,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.accent,
              inactiveTrackColor: Colors.white30,
              thumbColor: AppTheme.accent,
              overlayColor: AppTheme.accent.withOpacity(0.2),
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: Slider(
              value: feature.currentValue,
              min: 0,
              max: 10,
              divisions: 10,
              label: feature.currentValue.toInt().toString(),
              onChanged: (value) {
                if (onValueChanged != null) {
                  onValueChanged!(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
