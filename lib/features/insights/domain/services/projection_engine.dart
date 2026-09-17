import '../../../../core/money/dzd_amount.dart';

class MonthlyProjectionResult {
  const MonthlyProjectionResult({
    required this.spentSoFar,
    required this.budget,
    required this.projectedMonthEnd,
    required this.remainingBudget,
    required this.budgetProgressFraction,
    required this.pacePercentageVsBudget,
    required this.elapsedDays,
    required this.totalDaysInMonth,
    required this.isOverBudgetRisk,
  });

  final DzdAmount spentSoFar;
  final DzdAmount budget;
  final DzdAmount projectedMonthEnd;
  final DzdAmount remainingBudget;
  final double budgetProgressFraction; // 0.0 to 1.0+
  final double pacePercentageVsBudget; // e.g. +14% faster
  final int elapsedDays;
  final int totalDaysInMonth;
  final bool isOverBudgetRisk;
}

class ProjectionEngine {
  ProjectionEngine._();

  /// Calculates deterministic monthly spending pace and month-end projection.
  /// Always marked as an estimate.
  static MonthlyProjectionResult calculate({
    required DzdAmount spentSoFar,
    required DzdAmount budget,
    required DateTime currentDate,
  }) {
    final year = currentDate.year;
    final month = currentDate.month;
    // Calculate total days in current month
    final totalDaysInMonth = DateTime(year, month + 1, 0).day;
    final elapsedDays = currentDate.day.clamp(1, totalDaysInMonth);

    // If day 1 and zero spend, projection is zero
    if (spentSoFar.isZero) {
      return MonthlyProjectionResult(
        spentSoFar: DzdAmount.zero,
        budget: budget,
        projectedMonthEnd: DzdAmount.zero,
        remainingBudget: budget,
        budgetProgressFraction: 0.0,
        pacePercentageVsBudget: 0.0,
        elapsedDays: elapsedDays,
        totalDaysInMonth: totalDaysInMonth,
        isOverBudgetRisk: false,
      );
    }

    // projected = (spent / elapsed) * totalDays
    final elapsedFraction = elapsedDays / totalDaysInMonth;
    final projectedDinars = (spentSoFar.dinars / elapsedFraction).round();
    final projectedMonthEnd = DzdAmount(projectedDinars);

    final remainingDinars = budget.dinars - spentSoFar.dinars;
    final remainingBudget = DzdAmount(remainingDinars);

    final budgetProgressFraction = budget.dinars > 0
        ? (spentSoFar.dinars / budget.dinars).clamp(0.0, 2.0)
        : 1.0;

    // Expected spend by today if evenly pacing budget
    final expectedSpendByToday = budget.dinars * elapsedFraction;
    final paceVsBudget = expectedSpendByToday > 0
        ? ((spentSoFar.dinars - expectedSpendByToday) / expectedSpendByToday) *
              100
        : 0.0;

    final isOverBudgetRisk = projectedDinars > budget.dinars;

    return MonthlyProjectionResult(
      spentSoFar: spentSoFar,
      budget: budget,
      projectedMonthEnd: projectedMonthEnd,
      remainingBudget: remainingBudget,
      budgetProgressFraction: budgetProgressFraction,
      pacePercentageVsBudget: paceVsBudget,
      elapsedDays: elapsedDays,
      totalDaysInMonth: totalDaysInMonth,
      isOverBudgetRisk: isOverBudgetRisk,
    );
  }
}
