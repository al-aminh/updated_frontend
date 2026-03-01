import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get currentLocale => _locale;

  LanguageNotifier() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('language') ?? 'en';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    if (_locale.languageCode == 'en') {
      _locale = const Locale('bn');
      await prefs.setString('language', 'bn');
    } else {
      _locale = const Locale('en');
      await prefs.setString('language', 'en');
    }

    notifyListeners();
  }

  bool get isBangla => _locale.languageCode == 'bn';
}