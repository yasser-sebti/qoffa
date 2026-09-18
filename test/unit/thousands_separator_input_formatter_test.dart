import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/money/thousands_separator_input_formatter.dart';

void main() {
  group('ThousandsSeparatorInputFormatter Tests', () {
    final formatter = ThousandsSeparatorInputFormatter();

    test('formats simple and large numbers with comma separator in English and Arabic', () {
      final formatterEn = ThousandsSeparatorInputFormatter(isArabic: false);
      final formatterAr = ThousandsSeparatorInputFormatter(isArabic: true);

      final resEn = formatterEn.formatEditUpdate(
        const TextEditingValue(text: '1,000'),
        const TextEditingValue(
          text: '1000000',
          selection: TextSelection.collapsed(offset: 7),
        ),
      );
      expect(resEn.text, '1,000,000');
      expect(resEn.selection.end, 9);

      final resAr = formatterAr.formatEditUpdate(
        const TextEditingValue(text: '1،000'),
        const TextEditingValue(
          text: '1000000',
          selection: TextSelection.collapsed(offset: 7),
        ),
      );
      expect(resAr.text, '1،000،000');
      expect(resAr.selection.end, 9);
    });

    test('handles empty and clearing', () {
      final res = formatter.formatEditUpdate(
        const TextEditingValue(text: '500'),
        const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        ),
      );
      expect(res.text, '');
      expect(res.selection.end, 0);
    });
  });
}
