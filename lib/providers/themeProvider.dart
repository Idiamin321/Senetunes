import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _key = "theme";
  late SharedPreferences _preferences;
  bool _darkMode = true;

  bool get darkMode => _darkMode;

  ThemeProvider() {
    _loadFromPreferences();
  }

  Future<void> _initialPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> _savePreferences() async {
    await _initialPreferences();
    await _preferences.setBool(_key, _darkMode);
  }

  Future<void> _loadFromPreferences() async {
    await _initialPreferences();
    _darkMode = _preferences.getBool(_key) ?? true;
    notifyListeners();
  }

  void toggleChangeTheme() {
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}
