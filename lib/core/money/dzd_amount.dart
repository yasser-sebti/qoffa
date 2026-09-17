import 'package:decimal/decimal.dart';

/// Represents a whole Algerian Dinar (DZD / DA / دج) amount.
///
/// Binary floating point is strictly prohibited for monetary representation.
/// All monetary transactions, balances, and budgets in Qoffa are stored as 64-bit integers.
class DzdAmount implements Comparable<DzdAmount> {
  const DzdAmount(this.dinars);

  /// Creates a zero DZD amount.
  static const DzdAmount zero = DzdAmount(0);

  /// The monetary value stored as whole dinars.
  final int dinars;

  /// Calculates a total from a per-unit price in DZD and a decimal quantity,
  /// rounding half-up to the nearest whole dinar.
  factory DzdAmount.fromUnitAndQuantity({
    required DzdAmount unitPrice,
    required Decimal quantity,
  }) {
    final raw = Decimal.fromInt(unitPrice.dinars) * quantity;
    final rounded = raw.round();
    return DzdAmount(rounded.toBigInt().toInt());
  }

  /// Calculates unit price from total DZD and quantity.
  /// Returns micro-dinars (dinars * 1,000,000) for high precision comparisons.
  Decimal toPerBaseUnitRate(Decimal baseQuantity) {
    if (baseQuantity == Decimal.zero) return Decimal.zero;
    return (Decimal.fromInt(dinars) / baseQuantity).toDecimal(
      scaleOnInfinitePrecision: 4,
    );
  }

  DzdAmount operator +(DzdAmount other) => DzdAmount(dinars + other.dinars);
  DzdAmount operator -(DzdAmount other) => DzdAmount(dinars - other.dinars);
  DzdAmount operator *(int factor) => DzdAmount(dinars * factor);
  DzdAmount operator ~/(int divisor) => DzdAmount(dinars ~/ divisor);
  DzdAmount operator -() => DzdAmount(-dinars);

  bool operator <(DzdAmount other) => dinars < other.dinars;
  bool operator <=(DzdAmount other) => dinars <= other.dinars;
  bool operator >(DzdAmount other) => dinars > other.dinars;
  bool operator >=(DzdAmount other) => dinars >= other.dinars;

  bool get isNegative => dinars < 0;
  bool get isPositive => dinars > 0;
  bool get isZero => dinars == 0;

  DzdAmount abs() => DzdAmount(dinars.abs());

  /// Formats the DZD amount according to language.
  /// Examples:
  /// - en: "34,700 DA" or "+20 DA" (if showSign is true)
  /// - fr: "34 700 DA"
  /// - ar: "34 700 دج"
  String format({
    String locale = 'en',
    bool showSign = false,
    bool showSymbol = true,
  }) {
    final absDinars = dinars.abs();
    final digits = absDinars.toString();
    final buffer = StringBuffer();

    final separator = (locale == 'ar' || locale == 'fr') ? ' ' : ',';
    final len = digits.length;
    for (var i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(digits[i]);
    }

    final formattedNumber = buffer.toString();
    final signStr = showSign && dinars > 0
        ? '+'
        : dinars < 0
        ? '-'
        : '';

    if (!showSymbol) {
      return '$signStr$formattedNumber';
    }

    if (locale == 'ar') {
      return '$signStr$formattedNumber دج';
    } else {
      return '$signStr$formattedNumber DA';
    }
  }

  @override
  int compareTo(DzdAmount other) => dinars.compareTo(other.dinars);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is DzdAmount && dinars == other.dinars);

  @override
  int get hashCode => dinars.hashCode;

  @override
  String toString() => format();
}
