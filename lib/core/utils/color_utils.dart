import 'package:flutter/material.dart';

class ColorUtils {
  // Single consistent green color for all farmer avatars
  static Color getAvatarColor(String name) {
    return Colors.green.shade100; // Same green for everyone
  }

  static Color getAvatarTextColor(String name) {
    return Colors.green.shade900; // Dark green text
  }
}
