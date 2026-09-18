import 'package:flutter/widgets.dart';

/// Centralized number and currency formatting utility for Qoffa.
///
/// In Arabic (RTL) contexts, standard ASCII commas (',', U+002C) can trigger
/// Unicode Bidirectional Algorithm (Bidi) reordering, causing digits following
/// the comma to render on the opposite side (e.g. "500,12" instead of "12,500").
///
/// Using the Arabic comma ('،', U+060C) fixes this globally across all Arabic
/// surfaces while preserving standard commas for English and French.
class QoffaNumberFormat {
  QoffaNumberFormat._();

  /// Standard Arabic comma separator (U+060C)
  static const String arabicComma = '،';

  /// Standard Latin comma separator (U+002C)
  static const String latinComma = ',';

  /// Formats an integer or numeric value with thousands separators.
  /// When [isArabic] is true, uses the Arabic comma ('،') to prevent RTL digit flipping.
  static String format(num number, {bool isArabic = false}) {
    final isNegative = number < 0;
    final intPart = number.abs().round();
    final str = intPart.toString();
    final separator = isArabic ? arabicComma : latinComma;

    final formatted = str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}$separator',
    );

    return isNegative ? '-$formatted' : formatted;
  }

  /// Context-aware formatting that automatically detects if Arabic is active.
  static String formatWithContext(BuildContext context, num number) {
    final isArabic =
        Localizations.maybeLocaleOf(context)?.languageCode == 'ar' ||
        Directionality.maybeOf(context) == TextDirection.rtl;
    return format(number, isArabic: isArabic);
  }

  /// Removes all thousands separators (both Arabic '،' and Latin ',') and whitespace
  /// to safely parse numeric input.
  static String clean(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.replaceAll(RegExp(r'[,،\s]'), '').trim();
  }

  /// Safely parses an integer from user input containing potential thousands separators.
  static int? tryParseInt(String? text) {
    final cleaned = clean(text);
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }
}
