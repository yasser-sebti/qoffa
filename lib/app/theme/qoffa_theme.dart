import 'package:flutter/material.dart';
import 'qoffa_colors.dart';
import 'qoffa_tokens.dart';

class QoffaTheme {
  QoffaTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: QoffaColors.actionGreen,
      scaffoldBackgroundColor: QoffaColors.paleMintBackground,
      fontFamily: 'Alexandria',
      colorScheme: const ColorScheme.light(
        primary: QoffaColors.actionGreen,
        onPrimary: QoffaColors.whiteSurface,
        secondary: QoffaColors.brandGreen,
        surface: QoffaColors.whiteSurface,
        onSurface: QoffaColors.primaryNavy,
        error: QoffaColors.warningCoral,
      ),
      cardTheme: CardThemeData(
        color: QoffaColors.whiteSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Hero Sandwich Pro',
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: QoffaColors.primaryNavy,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: QoffaColors.brandGreen,
      scaffoldBackgroundColor: QoffaColors.darkBackground,
      fontFamily: 'Alexandria',
      colorScheme: const ColorScheme.dark(
        primary: QoffaColors.brandGreen,
        onPrimary: QoffaColors.primaryNavy,
        secondary: QoffaColors.actionGreen,
        surface: QoffaColors.darkSurface,
        onSurface: QoffaColors.darkTextPrimary,
        error: QoffaColors.warningCoral,
      ),
      cardTheme: CardThemeData(
        color: QoffaColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Hero Sandwich Pro',
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: QoffaColors.darkTextPrimary,
        ),
      ),
    );
  }
}
