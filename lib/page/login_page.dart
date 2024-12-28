import 'package:flutter/material.dart';
import 'package:game/client/api_client.dart';
import 'package:game/page/register_page.dart';
import 'package:game/theme/theme.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final apiClient = ApiClient();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppTheme.paddingLarge),

                    // Welcome text
                    ShaderMask(
                      shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                      child: Text(
                        'Welcome Back!',
                        style: AppTheme.headingStyle,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingLarge),

                    // Email Field
                    _buildInputField(
                      _emailController,
                      'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),

                    // Password Field
                    _buildPasswordField(
                      _passwordController,
                      'Password',
                      isVisible: isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() => isPasswordVisible = !isPasswordVisible);
                      },
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: ShaderMask(
                          shaderCallback: (bounds) => 
                              AppTheme.accentGradient.createShader(bounds),
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingLarge),

                    // Continue Button
                    Container(
                      decoration: AppTheme.buttonBoxDecoration,
                      child: ElevatedButton(
                        style: AppTheme.buttonStyle,
                        onPressed: _handleLogin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Continue', style: AppTheme.buttonTextStyle),
                            const SizedBox(width: AppTheme.paddingSmall),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style: AppTheme.bodyStyle),
                        GestureDetector(
                          onTap: () {Navigator.pushReplacementNamed(context, '/register');},
                          child: ShaderMask(
                            shaderCallback: (bounds) => 
                                AppTheme.accentGradient.createShader(bounds),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.paddingLarge),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
    IconData? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.white60)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingSmall,
            vertical: AppTheme.paddingSmall,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint, {
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white60),
          suffixIcon: InkWell(
            onTap: onToggleVisibility,
            child: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white60,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingSmall,
            vertical: AppTheme.paddingSmall,
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      final response = await apiClient.login(email, password);
      if (response) {
        Navigator.pushReplacementNamed(context, '/game-home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
}
