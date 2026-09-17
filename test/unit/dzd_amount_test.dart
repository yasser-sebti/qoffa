import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/money/dzd_amount.dart';

void main() {
  group('DzdAmount (Exact Integer Dinar Math)', () {
    test('creates zero amount', () {
      expect(DzdAmount.zero.dinars, 0);
      expect(DzdAmount.zero.isZero, isTrue);
      expect(DzdAmount.zero.isPositive, isFalse);
    });

    test('performs exact addition and subtraction without float drift', () {
      final a = DzdAmount(1450);
      final b = DzdAmount(250);

      expect((a + b).dinars, 1700);
      expect((a - b).dinars, 1200);
    });

    test('multiplies integer factor correctly', () {
      final a = DzdAmount(350);
      expect((a * 3).dinars, 1050);
    });

    test('computes decimal quantity pricing with standard half-up rounding', () {
      // 1.5 kg of apples at 230 DZD/kg = 345 DZD
      final pricePerUnit = DzdAmount(230);
      final total = DzdAmount.fromUnitAndQuantity(
        unitPrice: pricePerUnit,
        quantity: Decimal.parse('1.5'),
      );
      expect(total.dinars, 345);

      // 0.333 kg at 100 DZD/kg = 33.3 -> rounds to 33 DZD
      final total2 = DzdAmount.fromUnitAndQuantity(
        unitPrice: DzdAmount(100),
        quantity: Decimal.parse('0.333'),
      );
      expect(total2.dinars, 33);
    });

    test('computes price difference correctly', () {
      final oldPrice = DzdAmount(100);
      final newPrice = DzdAmount(120);

      final diff = newPrice - oldPrice;
      expect(diff.dinars, 20);
    });

    test('formats correctly in Arabic and Latin', () {
      final amount = DzdAmount(34700);
      expect(amount.format(locale: 'ar'), contains('34'));
      expect(amount.format(locale: 'ar'), contains('دج'));

      expect(amount.format(locale: 'fr'), contains('34'));
      expect(amount.format(locale: 'fr'), contains('DA'));

      expect(amount.format(locale: 'en'), contains('34'));
      expect(amount.format(locale: 'en'), contains('DA'));
    });

    test('handles comparisons correctly', () {
      final small = DzdAmount(500);
      final big = DzdAmount(1000);

      expect(small < big, isTrue);
      expect(big > small, isTrue);
      expect(small <= DzdAmount(500), isTrue);
      expect(small == DzdAmount(500), isTrue);
    });
  });
}
