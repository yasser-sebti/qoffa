class QoffaTokens {
  QoffaTokens._();

  // Spacing Scale
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;

  // Corner Radii
  static const double radiusControls = 12.0; // Chips, badges, small buttons
  static const double radiusFields = 16.0; // Input fields, steppers
  static const double radiusCompact = 22.0; // Compact cards, list tiles
  static const double radiusMajor = 28.0; // Major cards, bottom sheets
  static const double radiusPill = 999.0; // Fully circular pill ends

  // Touch Target Minimum
  static const double minTouchTarget = 48.0;

  // Responsive layout
  static const double compactBreakpoint = 380.0;
  static const double contentMaxWidth = 680.0;

  // Tactile Press Constants
  static const double buttonShadowOffset = 6.0;
  static const double cardShadowOffset = 4.0;
  static const Duration pressDuration = Duration(milliseconds: 80);

  // One motion language across the app. Short motion is reserved for direct
  // manipulation, medium motion for local state changes, and long motion for
  // screen-level reveals.
  static const Duration motionFast = Duration(milliseconds: 120);
  static const Duration motionMedium = Duration(milliseconds: 220);
  static const Duration motionSlow = Duration(milliseconds: 360);
  static const Duration stagger = Duration(milliseconds: 45);
}
