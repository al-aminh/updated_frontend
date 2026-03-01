import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenNotifier extends ChangeNotifier {
  static const int initialTokens = 1000;
  int _tokens = initialTokens;

  int get tokens => _tokens;

  TokenNotifier() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _tokens = prefs.getInt('ui_tokens') ?? initialTokens;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ui_tokens', _tokens);
  }

  bool canSpend(int cost) => _tokens >= cost;

  Future<bool> spend(int cost) async {
    if (!canSpend(cost)) return false;
    _tokens -= cost;
    await _save();
    notifyListeners();
    return true;
  }

  Future<void> reset() async {
    _tokens = initialTokens;
    await _save();
    notifyListeners();
  }
}