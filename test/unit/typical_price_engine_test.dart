import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/money/dzd_amount.dart';
import 'package:qoffa/features/insights/domain/services/typical_price_engine.dart';

void main() {
  group('TypicalPriceEngine (Median + IQR Outlier Filter)', () {
    test('returns null when observations are less than 3', () {
      final res = TypicalPriceEngine.calculate([
        DzdAmount(150),
        DzdAmount(160),
      ]);
      expect(res, isNull);
    });

    test('calculates typical range accurately for 3 observations', () {
      final res = TypicalPriceEngine.calculate([
        DzdAmount(140),
        DzdAmount(150),
        DzdAmount(160),
      ]);
      expect(res, isNotNull);
      expect(res!.sampleSize, 3);
      expect(res.medianPrice.dinars, 150);
      expect(res.describePrice(DzdAmount(150)), contains('Within'));
    });

    test('filters extreme outlier typo when >= 5 observations exist', () {
      // 5 normal observations around 150 DA, plus a 1500 DA typo
      final prices = [
        DzdAmount(145),
        DzdAmount(150),
        DzdAmount(155),
        DzdAmount(150),
        DzdAmount(148),
        DzdAmount(1500), // Typo!
      ];

      final res = TypicalPriceEngine.calculate(prices);
      expect(res, isNotNull);
      // The median should remain around 150 DA, not pulled by 1500 DA
      expect(res!.medianPrice.dinars, closeTo(150, 5));
      expect(res.isHighPrice(DzdAmount(1500)), isTrue);
    });
  });
}
