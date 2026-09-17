import 'package:flutter/material.dart';

/// Semantic color tokens for Qoffa · قفة
/// Reinterprets the reference mockups using the selected grocery-green palette.
class QoffaColors {
  QoffaColors._();

  // Primary Grocery Greens
  static const Color brandGreen = Color(0xFF0AA343);
  static const Color actionGreen = Color(0xFF087D34); // Accessible on white
  static const Color pressedGreen = Color(0xFF056629);

  // Mint Backgrounds & Surfaces
  static const Color paleMintBackground = Color(0xFFE8FFEE);
  static const Color mintSurfaceTint = Color(0xFFDDF7E5);
  static const Color whiteSurface = Color(0xFFFFFFFF);
  static const Color softBorder = Color(0xFFCAE6D2);

  // Typography Colors
  static const Color primaryNavy = Color(0xFF071936);
  static const Color secondarySage = Color(0xFF6E857A);
  static const Color mutedText = Color(0xFF8FA397);

  // Semantic Status Colors
  static const Color warningCoral = Color(
    0xFFFF6264,
  ); // Price increase, Later Buy
  static const Color warningCoralDeep = Color(0xFFD94547);
  static const Color noteYellow = Color(0xFFFFB416); // Food Notebook
  static const Color noteYellowDeep = Color(0xFFD69308);
  static const Color eventMint = Color(0xFF22C98D); // Purchase timeline dot
  static const Color priceDecrease = Color(
    0xFF0AA343,
  ); // Cheaper than last time
  static const Color goldAccent = Color(0xFFFFC000);

  // Secondary Accents
  static const Color skyBlue = Color(0xFF0877EC);
  static const Color skyBlueSoft = Color(0xFFE5F1FF);

  // Dark Theme Tokens
  static const Color darkBackground = Color(0xFF0B141C);
  static const Color darkSurface = Color(0xFF14222E);
  static const Color darkSurfaceElevated = Color(0xFF1C2E3D);
  static const Color darkBorder = Color(0xFF233B4E);
  static const Color darkTextPrimary = Color(0xFFF0F5F2);
  static const Color darkTextSecondary = Color(0xFF9CB2A6);

  /// Dynamically computes a harmonious tactile drop shadow color for buttons and cards.
  /// Shifts HSL lightness down by 22% and scales saturation.
  static Color smartShadow(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);
    if (hsl.lightness >= 0.85) {
      // For white / light surfaces, use subtle navy tint shadow
      return const Color(0xFF071936).withValues(alpha: 0.10);
    }
    final targetLightness = (hsl.lightness - 0.22).clamp(0.12, 0.40);
    final targetSaturation = (hsl.saturation * 1.05).clamp(0.0, 1.0);
    return hsl
        .withLightness(targetLightness)
        .withSaturation(targetSaturation)
        .toColor();
  }
}
