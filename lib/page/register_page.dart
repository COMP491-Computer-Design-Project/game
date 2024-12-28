import 'package:flutter/material.dart';
import 'package:game/client/api_client.dart';
import 'package:game/page/home_page.dart';
import 'package:game/theme/theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  final apiClient = ApiClient();

  bool _passwordVisible = false;
  bool _retypePasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            // Add Center widget
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Add this
                  children: [

                    // Logo
                    Image.asset(
                      'assets/logo.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppTheme.paddingLarge),

                    // Title
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.accentGradient.createShader(bounds),
                      child: Text(
                        'Create an Account',
                        style: AppTheme.headingStyle,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingLarge),

                    // Form Fields
                    _buildInputField(_usernameController, 'Username'),
                    const SizedBox(height: AppTheme.paddingSmall),
                    _buildInputField(_emailController, 'Email Address',
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: AppTheme.paddingSmall),
                    _buildPasswordField(_passwordController, 'Password',
                        isVisible: _passwordVisible,
                        onToggleVisibility: () => setState(
                            () => _passwordVisible = !_passwordVisible)),
                    const SizedBox(height: AppTheme.paddingSmall),
                    _buildPasswordField(
                        _retypePasswordController, 'Retype Password',
                        isVisible: _retypePasswordVisible,
                        onToggleVisibility: () => setState(() =>
                            _retypePasswordVisible = !_retypePasswordVisible)),
                    const SizedBox(height: AppTheme.paddingLarge),

                    // Create Button
                    Container(
                      decoration: AppTheme.buttonBoxDecoration,
                      child: ElevatedButton(
                        style: AppTheme.buttonStyle,
                        onPressed: _handleRegister,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Create Account',
                                style: AppTheme.buttonTextStyle),
                            const SizedBox(width: AppTheme.paddingSmall),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",
                            style: AppTheme.bodyStyle),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                AppTheme.accentGradient.createShader(bounds),
                            child: const Text(
                              'Login',
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

  // Helper method for input fields
  Widget _buildInputField(TextEditingController controller, String hint,
      {TextInputType? keyboardType}) {
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingSmall,
              vertical: AppTheme.paddingSmall),
        ),
      ),
    );
  }

  // Helper method for password fields
  Widget _buildPasswordField(TextEditingController controller, String hint,
      {required bool isVisible, required VoidCallback onToggleVisibility}) {
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingSmall,
              vertical: AppTheme.paddingSmall),
          suffixIcon: InkWell(
            onTap: onToggleVisibility,
            child: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white60,
            ),
          ),
        ),
      ),
    );
  }

  // Handler for register button
  Future<void> _handleRegister() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      final username = _usernameController.text;
      final response = await apiClient.register(email, password, username);
      if (response) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }
}
