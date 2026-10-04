import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// THEME
ValueNotifier<ThemeMode>
themeNotifier =
ValueNotifier(
  ThemeMode.dark,
);

/// LANGUAGE
ValueNotifier<Locale>
localeNotifier =
ValueNotifier(
  const Locale('ar'),
);

class AppState {

  /// LOAD SETTINGS
  static Future<void>
  loadSettings() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    /// THEME
    final isDark =
        prefs.getBool(
          "isDark",
        ) ??
            true;

    themeNotifier.value =
    isDark
        ? ThemeMode.dark
        : ThemeMode.light;

    /// LANGUAGE
    final language =
        prefs.getString(
          "language",
        ) ??
            "ar";

    localeNotifier.value =
        Locale(language);
  }

  /// CHANGE THEME
  static Future<void>
  changeTheme(
      bool isDark,
      ) async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setBool(
      "isDark",
      isDark,
    );

    themeNotifier.value =
    isDark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  /// CHANGE LANGUAGE
  static Future<void>
  changeLanguage(
      String languageCode,
      ) async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setString(
      "language",
      languageCode,
    );

    localeNotifier.value =
        Locale(languageCode);
  }
}