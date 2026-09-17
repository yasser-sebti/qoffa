import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/features/insights/domain/services/habit_engine.dart';

void main() {
  group('HabitEngine (Restock Interval & Due Date Detection)', () {
    test('returns null when less than 3 purchase events exist', () {
      final habit = HabitEngine.detect(
        purchaseDates: [
          DateTime(2026, 9, 1),
          DateTime(2026, 9, 8),
        ],
        today: DateTime(2026, 9, 15),
      );
      expect(habit, isNull);
    });

    test('detects weekly grocery habit with high confidence', () {
      // Bought every 7 days: Sept 1, Sept 8, Sept 15
      final habit = HabitEngine.detect(
        purchaseDates: [
          DateTime(2026, 9, 1),
          DateTime(2026, 9, 8),
          DateTime(2026, 9, 15),
        ],
        today: DateTime(2026, 9, 22),
      );

      expect(habit, isNotNull);
      expect(habit!.medianDaysInterval, 7);
      expect(habit.estimatedDueDate, DateTime(2026, 9, 22));
      expect(habit.isDueNow, isTrue);
      expect(habit.confidenceScore, greaterThanOrEqualTo(0.8));
    });

    test('marks not due when recently restocked', () {
      final habit = HabitEngine.detect(
        purchaseDates: [
          DateTime(2026, 9, 1),
          DateTime(2026, 9, 8),
          DateTime(2026, 9, 15),
        ],
        today: DateTime(2026, 9, 16), // Just bought yesterday
      );

      expect(habit, isNotNull);
      expect(habit!.isDueNow, isFalse);
    });
  });
}
