class RestockHabit {
  const RestockHabit({
    required this.medianDaysInterval,
    required this.madDays,
    required this.lastPurchaseDate,
    required this.estimatedDueDate,
    required this.isDueNow,
    required this.confidenceScore, // 0.0 to 1.0
    required this.sampleSize,
  });

  final int medianDaysInterval;
  final int madDays; // Median Absolute Deviation
  final DateTime lastPurchaseDate;
  final DateTime estimatedDueDate;
  final bool isDueNow;
  final double confidenceScore;
  final int sampleSize;
}

class HabitEngine {
  HabitEngine._();

  /// Detects recurring purchase habits for a product based on historical timestamps.
  ///
  /// Rules per Blueprint & PLAN:
  /// - Minimum 3 purchases required. Never claims a habit from 2 purchases.
  /// - Uses median interval and Median Absolute Deviation (MAD).
  static RestockHabit? detect({
    required List<DateTime> purchaseDates,
    required DateTime today,
  }) {
    if (purchaseDates.length < 3) return null;

    // Sort chronologically ascending
    final sorted = purchaseDates.map((d) => DateTime(d.year, d.month, d.day)).toList()
      ..sort((a, b) => a.compareTo(b));

    // Calculate gap intervals in days
    final gaps = <int>[];
    for (var i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff > 0) {
        gaps.add(diff);
      }
    }

    if (gaps.length < 2) return null;

    gaps.sort();
    final medianInterval = gaps[gaps.length ~/ 2];

    if (medianInterval <= 0) return null;

    // Compute Median Absolute Deviation (MAD)
    final deviations = gaps.map((g) => (g - medianInterval).abs()).toList()..sort();
    final mad = deviations[deviations.length ~/ 2];

    final lastDate = sorted.last;
    final estimatedDue = lastDate.add(Duration(days: medianInterval));

    // A product is "due now" if today is within [estimatedDue - mad, estimatedDue + mad]
    final daysSinceLast = today.difference(lastDate).inDays;
    final isDueNow = daysSinceLast >= (medianInterval - mad);

    // Confidence is higher when MAD is low relative to median interval
    final variationRatio = mad / medianInterval;
    final confidence = (1.0 - variationRatio * 0.5).clamp(0.2, 1.0);

    return RestockHabit(
      medianDaysInterval: medianInterval,
      madDays: mad,
      lastPurchaseDate: lastDate,
      estimatedDueDate: estimatedDue,
      isDueNow: isDueNow,
      confidenceScore: confidence,
      sampleSize: sorted.length,
    );
  }
}
