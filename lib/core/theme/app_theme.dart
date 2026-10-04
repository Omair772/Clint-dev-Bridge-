import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {

  /// LIGHT THEME
  static ThemeData lightTheme =
  ThemeData(

    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor:
    AppColors.lightBackground,

    fontFamily: 'Cairo',

    colorScheme:
    ColorScheme.fromSeed(

      seedColor:
      AppColors.primary,

      brightness:
      Brightness.light,
    ),

    appBarTheme: const AppBarTheme(

      elevation: 0,

      centerTitle: true,

      backgroundColor:
      Colors.transparent,

      foregroundColor:
      AppColors.lightTextPrimary,
    ),

    cardColor:
    AppColors.lightCard,

    inputDecorationTheme:
    InputDecorationTheme(

      filled: true,

      fillColor: Colors.white,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      border: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(20),

        borderSide:
        BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(20),

        borderSide: BorderSide(
          color:
          Colors.grey.shade200,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(20),

        borderSide:
        const BorderSide(
          color:
          AppColors.primary,
          width: 2,
        ),
      ),
    ),

    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(

        elevation: 0,

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,

        minimumSize:
        const Size(
          double.infinity,
          58,
        ),

        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(
            20,
          ),
        ),

        textStyle:
        const TextStyle(

          fontSize: 17,

          fontWeight:
          FontWeight.bold,
        ),
      ),
    ),

    cardTheme:
    CardThemeData(

      elevation: 0,

      color: Colors.white,

      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(
          24,
        ),
      ),
    ),
  );

  /// DARK THEME
  static ThemeData darkTheme =
  ThemeData(

    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor:
    AppColors.darkBackground,

    fontFamily: 'Cairo',

    colorScheme:
    ColorScheme.fromSeed(

      seedColor:
      AppColors.primary,

      brightness:
      Brightness.dark,
    ),

    appBarTheme: const AppBarTheme(

      elevation: 0,

      centerTitle: true,

      backgroundColor:
      Colors.transparent,

      foregroundColor:
      Colors.white,
    ),

    cardColor:
    AppColors.darkCard,

    inputDecorationTheme:
    InputDecorationTheme(

      filled: true,

      fillColor:
      AppColors.darkCard,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),

      border: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(20),

        borderSide:
        BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(20),

        borderSide:
        const BorderSide(
          color:
          AppColors.darkBorder,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(20),

        borderSide:
        const BorderSide(
          color:
          AppColors.primary,
          width: 2,
        ),
      ),
    ),

    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(

        elevation: 0,

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,

        minimumSize:
        const Size(
          double.infinity,
          58,
        ),

        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(
            20,
          ),
        ),

        textStyle:
        const TextStyle(

          fontSize: 17,

          fontWeight:
          FontWeight.bold,
        ),
      ),
    ),

    cardTheme:
    CardThemeData(

      elevation: 0,

      color:
      AppColors.darkCard,

      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(
          24,
        ),
      ),
    ),
  );
}