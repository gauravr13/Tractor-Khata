// =============================================================================
// PROJECT: Tractor Khata
// FILE: localization_service.dart
// DESCRIPTION:
// This file handles the application's localization (multi-language support).
// It includes:
// 1. AppLocalizations: Loads and provides translations from JSON files.
// 2. AppLocalizationsDelegate: Factory for creating AppLocalizations.
// 3. LocaleProvider: Manages the current locale state and persistence.
// =============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ---------------------------------------------------------------------------
/// Class: AppLocalizations
/// Purpose: Loads and stores translations from JSON files.
/// ---------------------------------------------------------------------------
class AppLocalizations {
  final Locale locale;
  Map<String, dynamic> _localizedStrings = {};

  AppLocalizations(this.locale);

  /// Helper method to access AppLocalizations from the widget tree
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Loads the JSON file corresponding to the current locale
  Future<void> load() async {
    // Load JSON file from assets (e.g., assets/translations/hi.json)
    String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    
    // Decode JSON into a Map
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap;
  }

  /// Translates a key into the localized string.
  /// Supports nested keys (e.g., 'home.title') and parameters (e.g., {name}).
  String translate(String key, {Map<String, String>? params}) {
    String? value = _getValue(key);
    
    // Return the key itself if translation is missing (fallback)
    if (value == null) return key;
    
    // Replace parameters if provided (e.g., "Hello {name}" -> "Hello Gaurav")
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        value = value!.replaceAll('{$paramKey}', paramValue);
      });
    }
    return value!;
  }

  /// Helper to retrieve value from nested map structure
  String? _getValue(String key) {
    List<String> keys = key.split('.');
    dynamic value = _localizedStrings;
    
    for (String k in keys) {
      if (value is Map && value.containsKey(k)) {
        value = value[k];
      } else {
        return null;
      }
    }
    return value?.toString();
  }
}

/// ---------------------------------------------------------------------------
/// Class: AppLocalizationsDelegate
/// Purpose: Factory for AppLocalizations.
/// ---------------------------------------------------------------------------
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  /// Returns true if the locale is supported by the app
  @override
  bool isSupported(Locale locale) {
    return ['hi', 'en'].contains(locale.languageCode);
  }

  /// Loads the localizations for the specific locale
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  /// Should return false if the load method doesn't need to be called again
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

/// ---------------------------------------------------------------------------
/// Class: LocaleProvider
/// Purpose: Manages the selected language state and persists it.
/// ---------------------------------------------------------------------------
class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale _locale = const Locale('hi'); // Default language is Hindi
  
  Locale get locale => _locale;

  /// Constructor: Loads saved locale or uses initial value
  LocaleProvider({String? initialLanguageCode}) {
    if (initialLanguageCode != null) {
      _locale = Locale(initialLanguageCode);
    } else {
      _loadSavedLocale();
    }
  }

  /// Loads the saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'hi';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  /// Sets a new locale and saves it to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners(); // Notify widgets to rebuild with new language
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Toggles between Hindi and English
  void toggleLanguage() {
    if (_locale.languageCode == 'hi') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('hi'));
    }
  }
}
