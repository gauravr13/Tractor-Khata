import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverProfile {
  final String name;
  final String? phone;
  final String? email;
  final String? photoPath; // Can be local path or URL

  DriverProfile({
    required this.name,
    this.phone,
    this.email,
    this.photoPath,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) => DriverProfile(
        name: json['name'] ?? 'Driver',
        phone: json['phone'],
        email: json['email'],
        photoPath: json['photoPath'],
      );
}

class DriverProvider with ChangeNotifier {
  DriverProfile _profile = DriverProfile(name: 'Driver');
  bool _isLoading = false;

  DriverProfile get profile => _profile;
  bool get isLoading => _isLoading;

  DriverProvider() {
    loadProfile();
  }

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

  Future<void> syncWithGoogle(User? user) async {
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    bool hasLocalData = prefs.containsKey('driver_name');

    // Only sync if no local data exists, OR if we want to force sync email (since email shouldn't change)
    // The user said: "email vhi rhe jo google acount se liya gya ho email editable n ho"
    // So we should ALWAYS ensure the email matches the Google account if it's not set or if we want to enforce it.
    // However, if the user edits the name locally, we shouldn't overwrite it with Google name on every restart.
    // So:
    // 1. If NO local name, use Google name.
    // 2. Always use Google email (or set it if missing).
    // 3. If NO local photo, use Google photo.

    String currentName = _profile.name;
    String? currentPhone = _profile.phone;
    String? currentEmail = _profile.email;
    String? currentPhoto = _profile.photoPath;

    bool needsUpdate = false;

    if (!hasLocalData || currentName == 'Driver') {
      currentName = user.displayName ?? 'Driver';
      needsUpdate = true;
    }

    if (currentEmail == null || currentEmail != user.email) {
      currentEmail = user.email;
      needsUpdate = true;
    }

    if (currentPhoto == null && user.photoURL != null) {
      currentPhoto = user.photoURL;
      needsUpdate = true;
    }
    
    // If phone is available in Google user (rarely), use it if local is null
    if (currentPhone == null && user.phoneNumber != null) {
      currentPhone = user.phoneNumber;
      needsUpdate = true;
    }

    if (needsUpdate) {
      await updateProfile(
        name: currentName,
        phone: currentPhone,
        email: currentEmail,
        photoPath: currentPhoto,
      );
    }
  }

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
