import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/money/thousands_separator_input_formatter.dart';

void main() {
  group('ThousandsSeparatorInputFormatter Tests', () {
    final formatter = ThousandsSeparatorInputFormatter();

    test('formats simple and large numbers with comma separator', () {
      final res1 = formatter.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(
          text: '100',
          selection: TextSelection.collapsed(offset: 3),
        ),
      );
      expect(res1.text, '100');
      expect(res1.selection.end, 3);

      final res2 = formatter.formatEditUpdate(
        const TextEditingValue(text: '100'),
        const TextEditingValue(
          text: '1000',
          selection: TextSelection.collapsed(offset: 4),
        ),
      );
      expect(res2.text, '1,000');
      expect(res2.selection.end, 5);

      final res3 = formatter.formatEditUpdate(
        const TextEditingValue(text: '1,000'),
        const TextEditingValue(
          text: '1000000',
          selection: TextSelection.collapsed(offset: 7),
        ),
      );
      expect(res3.text, '1,000,000');
      expect(res3.selection.end, 9);
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
