import 'package:flutter/material.dart';
import 'package:game/theme/theme.dart';
import 'package:game/home.dart';

class GameFinishedPage extends StatefulWidget {
  final double score;
  final bool isVictory;
  final String movieName;

  const GameFinishedPage({
    Key? key,
    required this.score,
    required this.isVictory,
    required this.movieName,
  }) : super(key: key);

  @override
  State<GameFinishedPage> createState() => _GameFinishedPageState();
}

class _GameFinishedPageState extends State<GameFinishedPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _scoreAnimation = Tween<double>(begin: 0.0, end: widget.score).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Result Icon with Animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    widget.isVictory ? Icons.emoji_events : Icons.warning_amber,
                    size: 80,
                    color: widget.isVictory ? Colors.amber : Colors.red,
                  ),
                ),
                const SizedBox(height: AppTheme.paddingLarge),

                // Result Text with Animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.accentGradient.createShader(bounds),
                    child: Text(
                      widget.isVictory ? 'Mission Complete!' : 'Mission Failed',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Movie Name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget.movieName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingLarge),

                // Score Display with Animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accent),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Final Score',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: AppTheme.paddingSmall),
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppTheme.accentGradient.createShader(bounds),
                              child: Text(
                                _scoreAnimation.value.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingLarge),

                // Return Home Button with Animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Return Home',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}