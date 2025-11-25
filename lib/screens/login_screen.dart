import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/localization_service.dart';

import '../providers/driver_provider.dart';

/// Login Screen.
/// Provides Google Sign-In functionality.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  /// Handles the Google Sign-In process.
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final credential = await authProvider.signInWithGoogle();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (credential != null) {
      // Sync driver profile with Google user
      await Provider.of<DriverProvider>(context, listen: false).syncWithGoogle(credential.user);
      // Navigate to Home Screen on success
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      final locale = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale.translate('login.sign_in_failed')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                locale.translate('login.welcome'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 48),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _handleGoogleSignIn,
                    icon: const Icon(Icons.login),
                    label: Text(locale.translate('login.sign_in_google')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
