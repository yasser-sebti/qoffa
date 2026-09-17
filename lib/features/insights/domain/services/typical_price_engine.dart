import '../../../../core/money/dzd_amount.dart';

class TypicalPriceRange {
  const TypicalPriceRange({
    required this.minPrice,
    required this.maxPrice,
    required this.medianPrice,
    required this.sampleSize,
    required this.q1,
    required this.q3,
    required this.iqr,
  });

  final DzdAmount minPrice;
  final DzdAmount maxPrice;
  final DzdAmount medianPrice;
  final int sampleSize;
  final int q1;
  final int q3;
  final int iqr;

  /// Explains the price position
  String describePrice(DzdAmount currentPrice) {
    if (currentPrice < minPrice) {
      final diff = minPrice - currentPrice;
      return '${diff.format()} below your usual range';
    } else if (currentPrice > maxPrice) {
      final diff = currentPrice - maxPrice;
      return '${diff.format()} above your usual range';
    } else {
      return 'Within your usual price range';
    }
  }

  bool isHighPrice(DzdAmount currentPrice) => currentPrice > maxPrice;
  bool isBargain(DzdAmount currentPrice) => currentPrice < minPrice;
}

class TypicalPriceEngine {
  TypicalPriceEngine._();

  /// Calculates a robust typical price range using Median and Interquartile Range (IQR).
  ///
  /// Rules per Blueprint & PLAN:
  /// - Minimum 3 comparable observations required.
  /// - At >= 5 observations, outliers are filtered using 1.5x IQR rule.
  /// - Never distorts usual range due to single typos.
  static TypicalPriceRange? calculate(List<DzdAmount> prices) {
    if (prices.length < 3) return null;

    // Sort ascending
    final sorted = prices.map((p) => p.dinars).toList()..sort();
    final n = sorted.length;

    // Filter outliers if >= 5 observations
    List<int> effective = sorted;
    if (n >= 5) {
      final q1Val = _percentile(sorted, 0.25);
      final q3Val = _percentile(sorted, 0.75);
      final iqrVal = q3Val - q1Val;
      final lowerFence = q1Val - (1.5 * iqrVal).round();
      final upperFence = q3Val + (1.5 * iqrVal).round();

      final filtered = sorted
          .where((p) => p >= lowerFence && p <= upperFence)
          .toList();
      if (filtered.length >= 3) {
        effective = filtered;
      }
    }

    final median = _percentile(effective, 0.50);
    final q1 = _percentile(effective, 0.25);
    final q3 = _percentile(effective, 0.75);
    final iqr = q3 - q1;

    return TypicalPriceRange(
      minPrice: DzdAmount(effective.first),
      maxPrice: DzdAmount(effective.last),
      medianPrice: DzdAmount(median),
      sampleSize: effective.length,
      q1: q1,
      q3: q3,
      iqr: iqr,
    );
  }

  static int _percentile(List<int> sorted, double p) {
    final index = p * (sorted.length - 1);
    final lower = index.floor();
    final upper = index.ceil();
    final weight = index - lower;

    if (lower == upper) return sorted[lower];
    return (sorted[lower] * (1 - weight) + sorted[upper] * weight).round();
  }
}
