import 'package:decimal/decimal.dart';
import 'unit_dimension.dart';

class UnitRegistry {
  UnitRegistry._();

  // Mass
  static final gram = QoffaUnit(
    id: 'g',
    dimension: UnitDimension.mass,
    symbolEn: 'g',
    symbolFr: 'g',
    symbolAr: 'غ',
    nameEn: 'Gram',
    nameFr: 'Gramme',
    nameAr: 'غرام',
    baseFactor: Decimal.one,
  );

  static final kilogram = QoffaUnit(
    id: 'kg',
    dimension: UnitDimension.mass,
    symbolEn: 'kg',
    symbolFr: 'kg',
    symbolAr: 'كغ',
    nameEn: 'Kilogram',
    nameFr: 'Kilogramme',
    nameAr: 'كيلوغرام',
    baseFactor: Decimal.fromInt(1000),
  );

  // Volume
  static final milliliter = QoffaUnit(
    id: 'ml',
    dimension: UnitDimension.volume,
    symbolEn: 'ml',
    symbolFr: 'ml',
    symbolAr: 'مل',
    nameEn: 'Milliliter',
    nameFr: 'Millilitre',
    nameAr: 'ميليلتر',
    baseFactor: Decimal.one,
  );

  static final centiliter = QoffaUnit(
    id: 'cl',
    dimension: UnitDimension.volume,
    symbolEn: 'cl',
    symbolFr: 'cl',
    symbolAr: 'سل',
    nameEn: 'Centiliter',
    nameFr: 'Centilitre',
    nameAr: 'سنتيلتر',
    baseFactor: Decimal.fromInt(10),
  );

  static final liter = QoffaUnit(
    id: 'L',
    dimension: UnitDimension.volume,
    symbolEn: 'L',
    symbolFr: 'L',
    symbolAr: 'ل',
    nameEn: 'Liter',
    nameFr: 'Litre',
    nameAr: 'لتر',
    baseFactor: Decimal.fromInt(1000),
  );

  // Count
  static final piece = QoffaUnit(
    id: 'piece',
    dimension: UnitDimension.count,
    symbolEn: 'pc',
    symbolFr: 'pce',
    symbolAr: 'قطعة',
    nameEn: 'Piece',
    nameFr: 'Pièce',
    nameAr: 'قطعة',
    baseFactor: Decimal.one,
  );

  static final dozen = QoffaUnit(
    id: 'dozen',
    dimension: UnitDimension.count,
    symbolEn: 'dz',
    symbolFr: 'dz',
    symbolAr: 'درزينة',
    nameEn: 'Dozen',
    nameFr: 'Douzaine',
    nameAr: 'درزينة (12)',
    baseFactor: Decimal.fromInt(12),
  );

  static final pack = QoffaUnit(
    id: 'pack',
    dimension: UnitDimension.custom,
    symbolEn: 'pack',
    symbolFr: 'paquet',
    symbolAr: 'علبة',
    nameEn: 'Pack',
    nameFr: 'Paquet',
    nameAr: 'علبة / باكي',
    baseFactor: Decimal.one,
  );

  static final tray = QoffaUnit(
    id: 'tray',
    dimension: UnitDimension.custom,
    symbolEn: 'tray',
    symbolFr: 'plateau',
    symbolAr: 'بلاطو',
    nameEn: 'Tray',
    nameFr: 'Plateau',
    nameAr: 'بلاطو',
    baseFactor: Decimal.one,
  );

  static final bottle = QoffaUnit(
    id: 'bottle',
    dimension: UnitDimension.custom,
    symbolEn: 'bottle',
    symbolFr: 'bouteille',
    symbolAr: 'قارورة',
    nameEn: 'Bottle',
    nameFr: 'Bouteille',
    nameAr: 'قرعة / قارورة',
    baseFactor: Decimal.one,
  );

  static final can = QoffaUnit(
    id: 'can',
    dimension: UnitDimension.custom,
    symbolEn: 'can',
    symbolFr: 'boîte',
    symbolAr: 'قوطي',
    nameEn: 'Can',
    nameFr: 'Boîte',
    nameAr: 'علبة معدنية',
    baseFactor: Decimal.one,
  );

  static final bag = QoffaUnit(
    id: 'bag',
    dimension: UnitDimension.custom,
    symbolEn: 'bag',
    symbolFr: 'sac',
    symbolAr: 'كيس',
    nameEn: 'Bag',
    nameFr: 'Sac',
    nameAr: 'كيس / صاشي',
    baseFactor: Decimal.one,
  );

  static final allUnits = <QoffaUnit>[
    kilogram,
    gram,
    liter,
    centiliter,
    milliliter,
    piece,
    dozen,
    pack,
    bottle,
    tray,
    can,
    bag,
  ];

  static final Map<String, QoffaUnit> _unitMap = {
    for (final unit in allUnits) unit.id: unit,
  };

  static QoffaUnit? findById(String id) => _unitMap[id];

  static QoffaUnit fromIdOrFallback(String id) => _unitMap[id] ?? piece;

  /// Returns whether two units can be directly converted without product-specific rules.
  static bool areCompatible(QoffaUnit u1, QoffaUnit u2) {
    if (u1.dimension == UnitDimension.custom ||
        u2.dimension == UnitDimension.custom) {
      // Custom units can only compare to themselves directly unless conversion is known
      return u1.id == u2.id;
    }
    return u1.dimension == u2.dimension;
  }

  /// Converts an amount from [fromUnit] to [toUnit].
  /// Returns null if units are dimensionally incompatible.
  static Decimal? convert({
    required Decimal value,
    required QoffaUnit fromUnit,
    required QoffaUnit toUnit,
  }) {
    if (!areCompatible(fromUnit, toUnit)) {
      return null;
    }
    if (fromUnit.id == toUnit.id) {
      return value;
    }

    // Convert to dimension base
    final inBase = value * fromUnit.baseFactor;
    // Convert from base to target
    return (inBase / toUnit.baseFactor).toDecimal(scaleOnInfinitePrecision: 6);
  }

  /// Normalizes to standard comparative base (kg, L, or piece)
  static ({Decimal normalizedQuantity, String normalizedUnitSymbol})?
  normalizeToBase({required Decimal quantity, required QoffaUnit unit}) {
    switch (unit.dimension) {
      case UnitDimension.mass:
        final inKg = convert(value: quantity, fromUnit: unit, toUnit: kilogram);
        return inKg == null
            ? null
            : (normalizedQuantity: inKg, normalizedUnitSymbol: 'kg');
      case UnitDimension.volume:
        final inL = convert(value: quantity, fromUnit: unit, toUnit: liter);
        return inL == null
            ? null
            : (normalizedQuantity: inL, normalizedUnitSymbol: 'L');
      case UnitDimension.count:
        final inPc = convert(value: quantity, fromUnit: unit, toUnit: piece);
        return inPc == null
            ? null
            : (normalizedQuantity: inPc, normalizedUnitSymbol: 'pc');
      case UnitDimension.custom:
        return (
          normalizedQuantity: quantity,
          normalizedUnitSymbol: unit.symbolEn,
        );
    }
  }
}
