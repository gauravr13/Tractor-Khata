// =============================================================================
// PROJECT: Tractor Khata
// FILE: driver_provider.dart
// DESCRIPTION:
// This provider handles the state for the Driver's (User's) Profile.
// It manages:
// 1. Loading/Saving profile data (Name, Phone, Email, Photo)
// 2. Syncing with Google Account (Name, Email, Photo)
// =============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------------------------------------------------------------------
/// Class: DriverProfile
/// Purpose: Data model for the driver's profile.
/// ---------------------------------------------------------------------------
class DriverProfile {
  final String name;
  final String? phone;
  final String? email;
  final String? photoPath; // Can be a local file path or a network URL

  DriverProfile({
    required this.name,
    this.phone,
    this.email,
    this.photoPath,
  });
}

/// ---------------------------------------------------------------------------
/// Class: DriverProvider
/// Purpose: State management for the Driver's Profile.
/// ---------------------------------------------------------------------------
class DriverProvider with ChangeNotifier {
  // Internal state
  DriverProfile _profile = DriverProfile(name: 'Driver');
  bool _isLoading = false;

  // Getters
  DriverProfile get profile => _profile;
  bool get isLoading => _isLoading;

  /// Constructor: Automatically loads the profile on initialization
  DriverProvider() {
    loadProfile();
  }

  /// ---------------------------------------------------------------------------
  /// Method: loadProfile
  /// Purpose: Loads profile data from SharedPreferences.
  /// ---------------------------------------------------------------------------
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('driver_name');
      
      if (name != null) {
        _profile = DriverProfile(
          name: name,
          phone: prefs.getString('driver_phone'),
          email: prefs.getString('driver_email'),
          photoPath: prefs.getString('driver_photo_path'),
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error loading driver profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------------------------------------------------------------------
  /// Method: syncWithGoogle
  /// Purpose: Syncs profile data with the Google Account after login.
  /// Logic:
  /// - Only overwrites Name if it's not set locally.
  /// - Always updates Email from Google (as it's non-editable).
  /// - Only updates Photo if local photo is missing.
  /// ---------------------------------------------------------------------------
  Future<void> syncWithGoogle(User? user) async {
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    bool hasLocalData = prefs.containsKey('driver_name');

    String currentName = _profile.name;
    String? currentPhone = _profile.phone;
    String? currentEmail = _profile.email;
    String? currentPhoto = _profile.photoPath;

    bool needsUpdate = false;

    // 1. Name: Use Google name if local name is default or missing
    if (!hasLocalData || currentName == 'Driver') {
      currentName = user.displayName ?? 'Driver';
      needsUpdate = true;
    }

    // 2. Email: Always sync with Google email
    if (currentEmail == null || currentEmail != user.email) {
      currentEmail = user.email;
      needsUpdate = true;
    }

    // 3. Photo: Use Google photo if local photo is missing
    if (currentPhoto == null && user.photoURL != null) {
      currentPhoto = user.photoURL;
      needsUpdate = true;
    }
    
    // 4. Phone: Use Google phone if local phone is missing (rarely available)
    if (currentPhone == null && user.phoneNumber != null) {
      currentPhone = user.phoneNumber;
      needsUpdate = true;
    }

    // Update only if changes are detected
    if (needsUpdate) {
      await updateProfile(
        name: currentName,
        phone: currentPhone,
        email: currentEmail,
        photoPath: currentPhoto,
      );
    }
  }

  /// ---------------------------------------------------------------------------
  /// Method: updateProfile
  /// Purpose: Updates profile data and saves to SharedPreferences.
  /// ---------------------------------------------------------------------------
  Future<void> updateProfile({
    required String name,
    String? phone,
    String? email,
    String? photoPath,
  }) async {
    _profile = DriverProfile(
      name: name,
      phone: phone,
      email: email,
      photoPath: photoPath,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_name', name);
    
    if (phone != null) {
      await prefs.setString('driver_phone', phone);
    } else {
      await prefs.remove('driver_phone');
    }

    if (email != null) {
      await prefs.setString('driver_email', email);
    } else {
      await prefs.remove('driver_email');
    }

    if (photoPath != null) {
      await prefs.setString('driver_photo_path', photoPath);
    } else {
      await prefs.remove('driver_photo_path');
    }
    
    notifyListeners();
  }

  /// ---------------------------------------------------------------------------
  /// Method: removePhoto
  /// Purpose: Removes the profile photo.
  /// ---------------------------------------------------------------------------
  Future<void> removePhoto() async {
    _profile = DriverProfile(
      name: _profile.name,
      phone: _profile.phone,
      email: _profile.email,
      photoPath: null,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('driver_photo_path');
    notifyListeners();
  }
}
