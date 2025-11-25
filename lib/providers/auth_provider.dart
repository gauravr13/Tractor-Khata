import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Provider class for managing Authentication state (Google Sign-In).
class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  /// Returns the current authenticated user.
  User? get user => _user;

  /// Returns true if the user is logged in.
  bool get isLoggedIn => _user != null;

  /// Constructor. Checks the current auth state on initialization.
  AuthProvider() {
    // Initialize with the current user immediately (for faster startup)
    _user = _auth.currentUser;
    
    // Listen to auth state changes for future updates
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Signs in the user using Google Sign-In.
  /// Returns the UserCredential on success, or null on failure.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in with Google: $e");
      }
      return null;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
