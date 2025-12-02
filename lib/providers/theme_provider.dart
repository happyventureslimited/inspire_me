import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = "theme_mode"; // stored value

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  ThemeProvider() {
    _loadThemeFromStorage();
  }

  // --------------------------------------------------------------
  // Load theme on startup
  // --------------------------------------------------------------
  Future<void> _loadThemeFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    if (value == "light") _mode = ThemeMode.light;
    if (value == "dark") _mode = ThemeMode.dark;
    if (value == "system" || value == null) _mode = ThemeMode.system;

    notifyListeners();
  }

  // --------------------------------------------------------------
  // Save theme on toggle
  // --------------------------------------------------------------
  Future<void> setTheme(ThemeMode newMode) async {
    _mode = newMode;

    final prefs = await SharedPreferences.getInstance();

    switch (newMode) {
      case ThemeMode.light:
        await prefs.setString(_key, "light");
        break;
      case ThemeMode.dark:
        await prefs.setString(_key, "dark");
        break;
      case ThemeMode.system:
        await prefs.setString(_key, "system");
        break;
    }

    notifyListeners();
  }

  // Convenience getters
  bool get isDark => _mode == ThemeMode.dark;
  bool get isLight => _mode == ThemeMode.light;
}
