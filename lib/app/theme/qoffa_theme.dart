import 'package:flutter/cupertino.dart';
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
      splashFactory: NoSplash.splashFactory,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          animationDuration: QoffaTokens.motionFast,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          animationDuration: QoffaTokens.motionFast,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(animationDuration: QoffaTokens.motionFast),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      cardTheme: CardThemeData(
        color: QoffaColors.whiteSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: QoffaColors.whiteSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Alexandria',
          color: QoffaColors.secondarySage,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Alexandria',
          color: QoffaColors.secondarySage.withValues(alpha: 0.72),
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
          borderSide: const BorderSide(
            color: QoffaColors.softBorder,
            width: 1.4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
          borderSide: const BorderSide(
            color: QoffaColors.softBorder,
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
          borderSide: const BorderSide(
            color: QoffaColors.actionGreen,
            width: 2,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: QoffaColors.softBorder,
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: QoffaColors.actionGreen,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
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
      splashFactory: NoSplash.splashFactory,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          animationDuration: QoffaTokens.motionFast,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          animationDuration: QoffaTokens.motionFast,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(animationDuration: QoffaTokens.motionFast),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      cardTheme: CardThemeData(
        color: QoffaColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusMajor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: QoffaColors.darkSurfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
          borderSide: const BorderSide(color: QoffaColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
          borderSide: const BorderSide(color: QoffaColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(QoffaTokens.radiusFields),
          borderSide: const BorderSide(color: QoffaColors.brandGreen, width: 2),
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
