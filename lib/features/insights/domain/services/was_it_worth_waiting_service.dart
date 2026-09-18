import 'package:decimal/decimal.dart';
import '../../../../core/money/dzd_amount.dart';
import '../../../../core/units/unit_registry.dart';

enum LaterBuyOutcomeType { savedMoney, paidMore, samePrice, incomparable }

class WasItWorthWaitingResult {
  const WasItWorthWaitingResult({
    required this.outcomeType,
    required this.daysWaited,
    required this.observedPrice,
    required this.finalPrice,
    required this.absoluteDifferenceDzd,
    required this.percentageDifference,
    required this.explanation,
    required this.isComparable,
  });

  final LaterBuyOutcomeType outcomeType;
  final int daysWaited;
  final DzdAmount observedPrice;
  final DzdAmount finalPrice;
  final DzdAmount
  absoluteDifferenceDzd; // positive = saved, negative = paid more
  final double percentageDifference; // e.g. -12.5%
  final String explanation;
  final bool isComparable;
}

class WasItWorthWaitingService {
  WasItWorthWaitingService._();

  /// Calculates whether waiting for a Later Buy item was worth it.
  static WasItWorthWaitingResult calculate({
    required DzdAmount observedPrice,
    required Decimal observedQuantity,
    required String observedUnitId,
    required DateTime observedDate,
    required DzdAmount finalPrice,
    required Decimal finalQuantity,
    required String finalUnitId,
    required DateTime purchaseDate,
  }) {
    final daysWaited = purchaseDate
        .difference(observedDate)
        .inDays
        .clamp(0, 9999);

    final uObs = UnitRegistry.fromIdOrFallback(observedUnitId);
    final uFinal = UnitRegistry.fromIdOrFallback(finalUnitId);

    // Fast-path: When units and quantities are identical, direct difference is exact and foolproof
    if ((uObs.id == uFinal.id || observedUnitId.toLowerCase() == finalUnitId.toLowerCase()) &&
        observedQuantity == finalQuantity) {
      final savingsDinars = observedPrice.dinars - finalPrice.dinars;
      final absDiff = DzdAmount(savingsDinars);
      final pctDiff = observedPrice.dinars > 0
          ? ((finalPrice.dinars - observedPrice.dinars) /
                  observedPrice.dinars) *
              100
          : 0.0;

      final LaterBuyOutcomeType outcome;
      final String explanation;
      if (savingsDinars > 0) {
        outcome = LaterBuyOutcomeType.savedMoney;
        explanation =
            'Waiting saved you ${absDiff.format()} (${pctDiff.abs().toStringAsFixed(1)}% less) over $daysWaited days!';
      } else if (savingsDinars < 0) {
        outcome = LaterBuyOutcomeType.paidMore;
        explanation =
            'Price increased by ${DzdAmount(-savingsDinars).format()} (${pctDiff.toStringAsFixed(1)}% more) after waiting $daysWaited days.';
      } else {
        outcome = LaterBuyOutcomeType.samePrice;
        explanation = 'The price remained identical after $daysWaited days.';
      }

      return WasItWorthWaitingResult(
        outcomeType: outcome,
        daysWaited: daysWaited,
        observedPrice: observedPrice,
        finalPrice: finalPrice,
        absoluteDifferenceDzd: absDiff,
        percentageDifference: pctDiff,
        explanation: explanation,
        isComparable: true,
      );
    }

    // If units are dimensionally incompatible
    if (!UnitRegistry.areCompatible(uObs, uFinal)) {
      return WasItWorthWaitingResult(
        outcomeType: LaterBuyOutcomeType.incomparable,
        daysWaited: daysWaited,
        observedPrice: observedPrice,
        finalPrice: finalPrice,
        absoluteDifferenceDzd: DzdAmount.zero,
        percentageDifference: 0.0,
        explanation:
            'Units ($observedUnitId vs $finalUnitId) are not directly comparable.',
        isComparable: false,
      );
    }

    // Convert both to base units to compare normalized rates
    final obsNorm = UnitRegistry.normalizeToBase(
      quantity: observedQuantity,
      unit: uObs,
    );
    final finalNorm = UnitRegistry.normalizeToBase(
      quantity: finalQuantity,
      unit: uFinal,
    );

    if (obsNorm == null || finalNorm == null) {
      return WasItWorthWaitingResult(
        outcomeType: LaterBuyOutcomeType.incomparable,
        daysWaited: daysWaited,
        observedPrice: observedPrice,
        finalPrice: finalPrice,
        absoluteDifferenceDzd: DzdAmount.zero,
        percentageDifference: 0.0,
        explanation: 'Could not normalize units for fair comparison.',
        isComparable: false,
      );
    }

    // Rate per base unit in DZD
    final obsRate =
        (Decimal.fromInt(observedPrice.dinars) / obsNorm.normalizedQuantity)
            .toDecimal(scaleOnInfinitePrecision: 4);

    // Calculate effective observed price for the final package quantity
    final equivalentObservedDinars = (obsRate * finalNorm.normalizedQuantity)
        .round()
        .toBigInt()
        .toInt();
    final effectiveObserved = DzdAmount(equivalentObservedDinars);

    // Savings = equivalent observed - final
    final savingsDinars = effectiveObserved.dinars - finalPrice.dinars;
    final absDiff = DzdAmount(savingsDinars);

    final pctDiff = effectiveObserved.dinars > 0
        ? ((finalPrice.dinars - effectiveObserved.dinars) /
                  effectiveObserved.dinars) *
              100
        : 0.0;

    LaterBuyOutcomeType outcome;
    String explanation;

    if (savingsDinars > 0) {
      outcome = LaterBuyOutcomeType.savedMoney;
      explanation =
          'Waiting saved you ${absDiff.format()} (${pctDiff.abs().toStringAsFixed(1)}% less) over $daysWaited days!';
    } else if (savingsDinars < 0) {
      outcome = LaterBuyOutcomeType.paidMore;
      explanation =
          'Price increased by ${DzdAmount(-savingsDinars).format()} (${pctDiff.toStringAsFixed(1)}% more) after waiting $daysWaited days.';
    } else {
      outcome = LaterBuyOutcomeType.samePrice;
      explanation = 'The price remained identical after $daysWaited days.';
    }

    return WasItWorthWaitingResult(
      outcomeType: outcome,
      daysWaited: daysWaited,
      observedPrice: observedPrice,
      finalPrice: finalPrice,
      absoluteDifferenceDzd: absDiff,
      percentageDifference: pctDiff,
      explanation: explanation,
      isComparable: true,
    );
  }
}
