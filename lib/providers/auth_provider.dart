// =============================================================================
// PROJECT: Tractor Khata
// FILE: auth_provider.dart
// DESCRIPTION:
// This provider handles the Authentication state using Firebase Auth and Google Sign-In.
// It manages:
// 1. User Login (Google Sign-In)
// 2. User Logout
// 3. Auth State Monitoring (Listening to changes)
// =============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// ---------------------------------------------------------------------------
/// Class: AuthProvider
/// Purpose: Manages user authentication state.
/// ---------------------------------------------------------------------------
class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  /// Returns the current authenticated user object
  User? get user => _user;

  /// Returns true if the user is currently logged in
  bool get isAuthenticated => _user != null;

  /// Constructor: Initializes auth state listener
  AuthProvider() {
    // Initialize with the current user immediately (Optimized for startup)
    _user = _auth.currentUser;
    
    // Listen to auth state changes (e.g., token expiry, logout)
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners(); // Notify UI to rebuild (e.g., redirect to login/home)
    });
  }

  /// ---------------------------------------------------------------------------
  /// Method: signInWithGoogle
  /// Purpose: Initiates the Google Sign-In flow.
  /// Returns: Future<UserCredential?> (Null if cancelled or failed)
  /// ---------------------------------------------------------------------------
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in process
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in with Google: $e");
      }
      return null;
    }
  }

  /// ---------------------------------------------------------------------------
  /// Method: signOut
  /// Purpose: Signs out the user from both Google and Firebase.
  /// ---------------------------------------------------------------------------
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
