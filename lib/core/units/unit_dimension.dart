import 'package:decimal/decimal.dart';

enum UnitDimension {
  mass,
  volume,
  count,
  custom,
}

class QoffaUnit {
  const QoffaUnit({
    required this.id,
    required this.dimension,
    required this.symbolEn,
    required this.symbolFr,
    required this.symbolAr,
    required this.nameEn,
    required this.nameFr,
    required this.nameAr,
    required this.baseFactor,
  });

  final String id;
  final UnitDimension dimension;
  final String symbolEn;
  final String symbolFr;
  final String symbolAr;
  final String nameEn;
  final String nameFr;
  final String nameAr;

  /// Factor to convert to base unit:
  /// Mass base: g (e.g., kg is 1000 g)
  /// Volume base: ml (e.g., L is 1000 ml, cl is 10 ml)
  /// Count base: piece (e.g., dozen is 12 pieces)
  final Decimal baseFactor;

  String localizedSymbol(String locale) {
    if (locale == 'ar') return symbolAr;
    if (locale == 'fr') return symbolFr;
    return symbolEn;
  }

  String localizedName(String locale) {
    if (locale == 'ar') return nameAr;
    if (locale == 'fr') return nameFr;
    return nameEn;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is QoffaUnit && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => symbolEn;
}
