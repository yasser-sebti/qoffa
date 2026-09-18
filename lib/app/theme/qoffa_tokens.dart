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

/// Standardized Typography Scale for Qoffa.
/// Provides a consistent, accessible text guide size architecture across the entire app.
class QoffaFontSize {
  QoffaFontSize._();

  /// Micro text: tags, tiny status indicators, badge counters (boosted from 10.0–11.0 -> 12.0)
  static const double micro = 12.0;

  /// Small caption: price calculator labels, card subtext (boosted from 11.0–12.0 -> 13.0)
  static const double caption = 13.0;

  /// Medium caption: budget usage captions, secondary metadata (boosted from 12.0–12.5 -> 13.5)
  static const double captionMedium = 13.5;

  /// Small body: control row labels, section links ("See all"), subtitle text (boosted from 12.5–13.0 -> 14.0)
  static const double bodySmall = 14.0;

  /// Regular body: quick-add items, dropdown choices, metadata badges (boosted from 13.5–14.0 -> 15.0)
  static const double body = 15.0;

  /// Medium body: tactile button labels, standard text inputs (boosted from 14.5–15.0 -> 16.0)
  static const double bodyMedium = 16.0;

  /// Small title: price values, card headers, list titles (boosted from 16.0–17.0 -> 17.5)
  static const double titleSmall = 17.5;

  /// Medium title: counter values, prominent item titles (boosted from 18.0 -> 19.5)
  static const double titleMedium = 19.5;

  /// Large title: modal dialog titles, progress numbers (boosted from 19.0–20.0 -> 21.0)
  static const double titleLarge = 21.0;

  /// Small headline: section headers, sheet titles (boosted from 22.0–23.0 -> 24.5)
  static const double headlineSmall = 24.5;

  /// Medium headline: page titles, hero subtitles (boosted from 26.0 -> 28.0)
  static const double headlineMedium = 28.0;

  /// Display hero: big budget totals, key metrics (boosted from 38.0 -> 40.0)
  static const double display = 40.0;
}

/// Common typography font family constants and helpers
class QoffaFontFamily {
  QoffaFontFamily._();

  static const String arabic = 'At Hauss Arabic';
  static const String latinBody = 'Inter';
  static const String latinDisplay = 'Hero Sandwich Pro';

  /// Body font family: null so that TextStyles automatically inherit
  /// the locale-appropriate primary font defined in ThemeData
  /// ('At Hauss Arabic' in Arabic, 'Inter' in Latin) without forcing Latin 'Inter'.
  static const String? body = null;

  /// Display font family: 'Hero Sandwich Pro'
  static const String display = latinDisplay;

  /// Global font fallback list ensuring Arabic glyphs are always rendered with At Hauss Arabic
  static const List<String> fallback = [arabic, latinBody, latinDisplay];
}

