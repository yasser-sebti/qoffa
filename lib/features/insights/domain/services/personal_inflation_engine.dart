class MatchedProductPriceComparison {
  const MatchedProductPriceComparison({
    required this.productId,
    required this.productName,
    required this.previousNormalizedRate,
    required this.currentNormalizedRate,
    required this.weightShareInPreviousPeriod, // 0.0 to 1.0
  });

  final String productId;
  final String productName;
  final double previousNormalizedRate;
  final double currentNormalizedRate;
  final double weightShareInPreviousPeriod;

  double get percentageChange {
    if (previousNormalizedRate <= 0) return 0.0;
    return ((currentNormalizedRate - previousNormalizedRate) /
            previousNormalizedRate) *
        100;
  }
}

class PersonalInflationResult {
  const PersonalInflationResult({
    required this.inflationRatePercentage,
    required this.matchedProductCount,
    required this.coveragePercentage, // percentage of past spend covered
    required this.highestIncreaseProductName,
    required this.highestIncreasePercentage,
    required this.isReliable,
  });

  final double inflationRatePercentage;
  final int matchedProductCount;
  final double coveragePercentage;
  final String? highestIncreaseProductName;
  final double highestIncreasePercentage;
  final bool isReliable;
}

class PersonalInflationEngine {
  PersonalInflationEngine._();

  /// Calculates a personalized grocery inflation rate across two periods.
  /// Requires at least 3 matched comparable product observations.
  static PersonalInflationResult? calculate({
    required List<MatchedProductPriceComparison> matchedProducts,
    required double totalPreviousPeriodSpend,
    required double matchedProductsPreviousSpend,
  }) {
    if (matchedProducts.length < 3) return null;

    final coverage = totalPreviousPeriodSpend > 0
        ? (matchedProductsPreviousSpend / totalPreviousPeriodSpend) * 100
        : 0.0;

    // Weighted percentage changes
    var totalWeightedChange = 0.0;
    var totalWeights = 0.0;
    MatchedProductPriceComparison? highest;

    for (final item in matchedProducts) {
      final change = item.percentageChange;
      totalWeightedChange += change * item.weightShareInPreviousPeriod;
      totalWeights += item.weightShareInPreviousPeriod;

      if (highest == null || change > highest.percentageChange) {
        highest = item;
      }
    }

    final inflationRate = totalWeights > 0
        ? (totalWeightedChange / totalWeights)
        : 0.0;

    return PersonalInflationResult(
      inflationRatePercentage: inflationRate,
      matchedProductCount: matchedProducts.length,
      coveragePercentage: coverage,
      highestIncreaseProductName: highest?.productName,
      highestIncreasePercentage: highest?.percentageChange ?? 0.0,
      isReliable: matchedProducts.length >= 5 && coverage >= 50.0,
    );
  }
}
