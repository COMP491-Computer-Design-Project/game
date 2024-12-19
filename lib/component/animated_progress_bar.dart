import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double progress; // Value between 0 and 1
  final int remaining; // Remaining increments
  final Color color;

  const AnimatedProgressBar({
    Key? key,
    required this.progress,
    required this.remaining,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12.0,
          ),
        ),
        // Remaining text
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0), // Padding to keep text inside the bar
              child: Text(
                '$remaining/30',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Adjust text color for visibility
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
