import 'package:flutter/material.dart';

import 'app_languages.dart';

class LocalizationService {

  static String currentLanguage =
      "en";

  static String tr(String key) {

    return AppLanguages
        .translations[
    currentLanguage]?[key] ??
        key;
  }

  static void changeLanguage(
      String languageCode,
      ) {

    currentLanguage =
        languageCode;
  }
}