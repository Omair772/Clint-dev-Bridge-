import 'package:flutter/material.dart';

class AppColors {

  /// PRIMARY
  static const Color primary =
  Color(0xff6C63FF);

  static const Color secondary =
  Color(0xff8E2DE2);

  static const Color accent =
  Color(0xff00C6FF);

  /// DARK MODE
  static const Color darkBackground =
  Color(0xff0D1117);

  static const Color darkCard =
  Color(0xff161B22);

  static const Color darkBorder =
  Color(0xff21262D);

  /// LIGHT MODE
  static const Color lightBackground =
  Color(0xffF8FAFC);

  static const Color lightCard =
      Colors.white;

  /// TEXT
  static const Color textPrimary =
  Color(0xffE6EDF3);

  static const Color textSecondary =
  Color(0xff9BA1A6);

  static const Color lightTextPrimary =
  Color(0xff111827);

  static const Color lightTextSecondary =
  Color(0xff6B7280);

  /// STATUS
  static const Color success =
  Color(0xff22C55E);

  static const Color warning =
  Color(0xffF59E0B);

  static const Color error =
  Color(0xffEF4444);

  /// GRADIENT
  static const LinearGradient
  primaryGradient = LinearGradient(

    colors: [
      Color(0xff4A00E0),
      Color(0xff8E2DE2),
    ],

    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient
  blueGradient = LinearGradient(

    colors: [
      Color(0xff00C6FF),
      Color(0xff0072FF),
    ],

    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}