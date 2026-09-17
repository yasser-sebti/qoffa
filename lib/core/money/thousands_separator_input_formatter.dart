import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// TextInputFormatter that automatically adds comma (',') thousands separators
/// as the user types integer amounts, maintaining accurate cursor position.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  ThousandsSeparatorInputFormatter({this.maxDigits = 9});

  final int maxDigits;
  static final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Extract only raw digits
    var digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Enforce max digits threshold if needed
    if (digitsOnly.length > maxDigits) {
      digitsOnly = digitsOnly.substring(0, maxDigits);
    }

    // Strip leading zeroes unless the whole value is just '0'
    final parsed = int.tryParse(digitsOnly);
    if (parsed == null) {
      return oldValue;
    }

    final formatted = _formatter.format(parsed);

    // Calculate updated cursor position by counting digits before the cursor in newValue
    final cursorIndex = newValue.selection.end.clamp(0, newValue.text.length);
    final digitsBeforeCursor = newValue.text
        .substring(0, cursorIndex)
        .replaceAll(RegExp(r'[^\d]'), '')
        .length;

    int newCursorIndex = 0;
    int digitCount = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (digitCount == digitsBeforeCursor) {
        break;
      }
      if (RegExp(r'\d').hasMatch(formatted[i])) {
        digitCount++;
      }
      newCursorIndex = i + 1;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newCursorIndex.clamp(0, formatted.length),
      ),
    );
  }
}
