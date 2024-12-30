import 'package:flutter/material.dart';

import 'login_page.dart';
import '../theme/theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Game Logo
                        Hero(
                          tag: 'gamelogo',
                          child: Image.asset(
                            'assets/logo.png',
                            height: 200,
                          ),
                        ),
                        const SizedBox(height: AppTheme.paddingLarge),
                        ShaderMask(
                          shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                          child: Text(
                            'Epic Adventure Awaits',
                            style: AppTheme.headingStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppTheme.paddingSmall),
                        Text(
                          'Welcome to the ultimate text-based adventure! In this game, you will engage in conversations with LLMs from various iconic movies. ',
                          style: AppTheme.bodyStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.paddingSmall),
                        Text(
                          'Explore captivating narratives, make choices that shape your journey, and work towards achieving your ultimate goal!',
                          style: AppTheme.bodyStyle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),


                  // Start Adventure Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.paddingLarge),
                    child: Container(
                      decoration: AppTheme.buttonBoxDecoration,
                      child: ElevatedButton(
                        style: AppTheme.buttonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Start Adventure',
                          style: AppTheme.buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
