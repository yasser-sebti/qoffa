import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/money/dzd_amount.dart';
import 'package:qoffa/features/insights/domain/services/was_it_worth_waiting_service.dart';

void main() {
  group('WasItWorthWaitingService', () {
    test('detects money saved when price decreased after waiting', () {
      // Observed at 220 DA, bought 5 days later at 180 DA
      final result = WasItWorthWaitingService.calculate(
        observedPrice: DzdAmount(220),
        observedQuantity: Decimal.one,
        observedUnitId: 'kg',
        observedDate: DateTime(2026, 9, 1),
        finalPrice: DzdAmount(180),
        finalQuantity: Decimal.one,
        finalUnitId: 'kg',
        purchaseDate: DateTime(2026, 9, 6),
      );

      expect(result.outcomeType, LaterBuyOutcomeType.savedMoney);
      expect(result.absoluteDifferenceDzd.dinars, 40); // 40 DA saved
      expect(result.daysWaited, 5);
      expect(result.isComparable, isTrue);
    });

    test('detects price increase when waiting was disadvantageous', () {
      // Observed at 150 DA, bought 3 days later at 170 DA
      final result = WasItWorthWaitingService.calculate(
        observedPrice: DzdAmount(150),
        observedQuantity: Decimal.one,
        observedUnitId: 'L',
        observedDate: DateTime(2026, 9, 10),
        finalPrice: DzdAmount(170),
        finalQuantity: Decimal.one,
        finalUnitId: 'L',
        purchaseDate: DateTime(2026, 9, 13),
      );

      expect(result.outcomeType, LaterBuyOutcomeType.paidMore);
      expect(result.absoluteDifferenceDzd.dinars, -20);
      expect(result.daysWaited, 3);
    });

    test('normalizes different package sizes (e.g. 500g vs 1kg)', () {
      // Observed 500g at 100 DA (rate: 200 DA/kg)
      // Bought 1kg at 180 DA (rate: 180 DA/kg -> equivalent observed: 200 DA)
      final result = WasItWorthWaitingService.calculate(
        observedPrice: DzdAmount(100),
        observedQuantity: Decimal.parse('500'),
        observedUnitId: 'g',
        observedDate: DateTime(2026, 9, 1),
        finalPrice: DzdAmount(180),
        finalQuantity: Decimal.one,
        finalUnitId: 'kg',
        purchaseDate: DateTime(2026, 9, 5),
      );

      expect(result.outcomeType, LaterBuyOutcomeType.savedMoney);
      expect(
        result.absoluteDifferenceDzd.dinars,
        20,
      ); // 200 - 180 = 20 DA saved
      expect(result.isComparable, isTrue);
    });

    test('marks incomparable units (e.g. bottle vs kg)', () {
      final result = WasItWorthWaitingService.calculate(
        observedPrice: DzdAmount(150),
        observedQuantity: Decimal.one,
        observedUnitId: 'bottle',
        observedDate: DateTime(2026, 9, 1),
        finalPrice: DzdAmount(150),
        finalQuantity: Decimal.one,
        finalUnitId: 'kg',
        purchaseDate: DateTime(2026, 9, 5),
      );

      expect(result.outcomeType, LaterBuyOutcomeType.incomparable);
      expect(result.isComparable, isFalse);
    });
  });
}
