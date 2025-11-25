import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, dynamic> _localizedStrings = {};

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<void> load() async {
    String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap;
  }

  String translate(String key, {Map<String, String>? params}) {
    String? value = _getValue(key);
    if (value == null) return key;
    
    // Replace parameters if provided
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        value = value!.replaceAll('{$paramKey}', paramValue);
      });
    }
    return value!;
  }

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

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['hi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale _locale = const Locale('hi'); // Default: Hindi
  
  Locale get locale => _locale;

  LocaleProvider({String? initialLanguageCode}) {
    if (initialLanguageCode != null) {
      _locale = Locale(initialLanguageCode);
    } else {
      _loadSavedLocale();
    }
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'hi';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  void toggleLanguage() {
    final newLocale = _locale.languageCode == 'hi' ? const Locale('en') : const Locale('hi');
    setLocale(newLocale);
  }
}
