// =============================================================================
// PROJECT: Tractor Khata
// FILE: login_screen.dart
// DESCRIPTION:
// This screen handles user authentication via Google Sign-In.
// It is the first screen shown to unauthenticated users.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/localization_service.dart';
import '../providers/driver_provider.dart';

/// ---------------------------------------------------------------------------
/// Screen: LoginScreen
/// Purpose: Displays the login UI and handles the sign-in flow.
/// ---------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  /// ---------------------------------------------------------------------------
  /// Method: _handleGoogleSignIn
  /// Purpose: Initiates Google Sign-In and navigates to home on success.
  /// ---------------------------------------------------------------------------
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
      // Sync driver profile with Google user data (Name, Email, Photo)
      await Provider.of<DriverProvider>(context, listen: false).syncWithGoogle(credential.user);
      
      // Navigate to Home Screen (Farmer List)
      // Note: We use pushReplacementNamed to prevent going back to login screen
      Navigator.pushReplacementNamed(context, '/farmer_list');
    } else {
      // Show error message if sign-in failed or was cancelled
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
              // --- App Logo ---
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
              
              // --- Welcome Text ---
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
              
              // --- Sign In Button ---
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
