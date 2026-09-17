import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/money/dzd_amount.dart';
import 'package:qoffa/features/insights/domain/services/projection_engine.dart';

void main() {
  group('ProjectionEngine (Deterministic Spending & Pace)', () {
    test('returns zero projection when spent is zero', () {
      final res = ProjectionEngine.calculate(
        spentSoFar: DzdAmount.zero,
        budget: DzdAmount(60000),
        currentDate: DateTime(2026, 9, 15),
      );

      expect(res.spentSoFar.isZero, isTrue);
      expect(res.projectedMonthEnd.isZero, isTrue);
      expect(res.remainingBudget.dinars, 60000);
      expect(res.isOverBudgetRisk, isFalse);
    });

    test('projects linear spending accurately at mid-month', () {
      // In September (30 days), on day 15 (halfway), spent 30,000 DA with 60,000 budget
      final res = ProjectionEngine.calculate(
        spentSoFar: DzdAmount(30000),
        budget: DzdAmount(60000),
        currentDate: DateTime(2026, 9, 15),
      );

      expect(res.elapsedDays, 15);
      expect(res.totalDaysInMonth, 30);
      expect(res.projectedMonthEnd.dinars, 60000);
      expect(res.isOverBudgetRisk, isFalse);
      expect(res.remainingBudget.dinars, 30000);
    });

    test('detects over-budget risk when spending pace is too high', () {
      // In September on day 10, already spent 30,000 out of 60,000
      // 30,000 / (10/30) = 90,000 projected!
      final res = ProjectionEngine.calculate(
        spentSoFar: DzdAmount(30000),
        budget: DzdAmount(60000),
        currentDate: DateTime(2026, 9, 10),
      );

      expect(res.projectedMonthEnd.dinars, 90000);
      expect(res.isOverBudgetRisk, isTrue);
      expect(res.pacePercentageVsBudget, greaterThan(0));
    });

    test('handles leap years correctly in February', () {
      // 2028 is a leap year (29 days in Feb)
      final res = ProjectionEngine.calculate(
        spentSoFar: DzdAmount(14500),
        budget: DzdAmount(30000),
        currentDate: DateTime(2028, 2, 14),
      );

      expect(res.totalDaysInMonth, 29);
      expect(res.elapsedDays, 14);
    });
  });
}
