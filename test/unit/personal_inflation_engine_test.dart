import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/features/insights/domain/services/personal_inflation_engine.dart';

void main() {
  group('PersonalInflationEngine (Matched Basket Personal Inflation)', () {
    test('returns null when less than 3 matched products exist', () {
      final res = PersonalInflationEngine.calculate(
        matchedProducts: [
          const MatchedProductPriceComparison(
            productId: '1',
            productName: 'Milk',
            previousNormalizedRate: 150,
            currentNormalizedRate: 165,
            weightShareInPreviousPeriod: 0.5,
          ),
        ],
        totalPreviousPeriodSpend: 1000,
        matchedProductsPreviousSpend: 500,
      );
      expect(res, isNull);
    });

    test('calculates weighted personal basket inflation correctly', () {
      final matches = [
        const MatchedProductPriceComparison(
          productId: '1',
          productName: 'Lait Candia',
          previousNormalizedRate: 140,
          currentNormalizedRate: 154, // +10%
          weightShareInPreviousPeriod: 0.4,
        ),
        const MatchedProductPriceComparison(
          productId: '2',
          productName: 'Café Boun',
          previousNormalizedRate: 250,
          currentNormalizedRate: 300, // +20%
          weightShareInPreviousPeriod: 0.4,
        ),
        const MatchedProductPriceComparison(
          productId: '3',
          productName: 'Sucre Cevital',
          previousNormalizedRate: 90,
          currentNormalizedRate: 90, // 0%
          weightShareInPreviousPeriod: 0.2,
        ),
      ];

      // Weighted average: (10% * 0.4) + (20% * 0.4) + (0% * 0.2) = 4 + 8 + 0 = 12%
      final res = PersonalInflationEngine.calculate(
        matchedProducts: matches,
        totalPreviousPeriodSpend: 2000,
        matchedProductsPreviousSpend: 1800,
      );

      expect(res, isNotNull);
      expect(res!.matchedProductCount, 3);
      expect(res.inflationRatePercentage, closeTo(12.0, 0.1));
      expect(res.highestIncreaseProductName, 'Café Boun');
      expect(res.highestIncreasePercentage, closeTo(20.0, 0.1));
      // With only 3 products, confidence is indicative (not yet fully reliable until >= 5 products)
      expect(res.isReliable, isFalse);
    });

    test('marks as fully reliable when >= 5 products and >= 50% coverage', () {
      final matches = [
        const MatchedProductPriceComparison(productId: '1', productName: 'A', previousNormalizedRate: 100, currentNormalizedRate: 110, weightShareInPreviousPeriod: 0.2),
        const MatchedProductPriceComparison(productId: '2', productName: 'B', previousNormalizedRate: 100, currentNormalizedRate: 110, weightShareInPreviousPeriod: 0.2),
        const MatchedProductPriceComparison(productId: '3', productName: 'C', previousNormalizedRate: 100, currentNormalizedRate: 110, weightShareInPreviousPeriod: 0.2),
        const MatchedProductPriceComparison(productId: '4', productName: 'D', previousNormalizedRate: 100, currentNormalizedRate: 110, weightShareInPreviousPeriod: 0.2),
        const MatchedProductPriceComparison(productId: '5', productName: 'E', previousNormalizedRate: 100, currentNormalizedRate: 110, weightShareInPreviousPeriod: 0.2),
      ];

      final res = PersonalInflationEngine.calculate(
        matchedProducts: matches,
        totalPreviousPeriodSpend: 1000,
        matchedProductsPreviousSpend: 800, // 80% coverage
      );

      expect(res, isNotNull);
      expect(res!.matchedProductCount, 5);
      expect(res.coveragePercentage, 80.0);
      expect(res.isReliable, isTrue);
    });
  });
}
