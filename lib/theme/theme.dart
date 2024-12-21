import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const primaryDark = Color(0xFF1A237E);
  static const primaryDarker = Color(0xFF000051);
  static const accent = Colors.orange;
  static const accentDark = Colors.deepOrange;

  // Gradients
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primaryDarker],
  );

  static const accentGradient = LinearGradient(
    colors: [accent, accentDark],
  );

  // Text Styles
  static const headingStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.white70,
    height: 1.5,
  );

  static const buttonTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  );

  // Spacing
  static const double paddingLarge = 32.0;
  static const double paddingMedium = 24.0;
  static const double paddingSmall = 16.0;

  // Button Style
  static final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: accent,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size(double.infinity, 60),
  );

  static final buttonBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: accent.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 10,
      ),
    ],
  );
} 