import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/units/unit_registry.dart';

void main() {
  group('UnitRegistry & Dimensional Conversion', () {
    test('finds standard units by id', () {
      expect(UnitRegistry.findById('kg'), equals(UnitRegistry.kilogram));
      expect(UnitRegistry.findById('g'), equals(UnitRegistry.gram));
      expect(UnitRegistry.findById('L'), equals(UnitRegistry.liter));
      expect(UnitRegistry.findById('cl'), equals(UnitRegistry.centiliter));
      expect(UnitRegistry.findById('piece'), equals(UnitRegistry.piece));
      expect(UnitRegistry.findById('dozen'), equals(UnitRegistry.dozen));
    });

    test('prevents cross-dimensional conversions (mass vs volume)', () {
      expect(
        UnitRegistry.areCompatible(UnitRegistry.kilogram, UnitRegistry.liter),
        isFalse,
      );
      final converted = UnitRegistry.convert(
        value: Decimal.fromInt(1),
        fromUnit: UnitRegistry.kilogram,
        toUnit: UnitRegistry.liter,
      );
      expect(converted, isNull);
    });

    test('converts mass correctly (grams to kilograms)', () {
      final converted = UnitRegistry.convert(
        value: Decimal.fromInt(500),
        fromUnit: UnitRegistry.gram,
        toUnit: UnitRegistry.kilogram,
      );
      expect(converted, Decimal.parse('0.5'));
    });

    test('converts volume correctly (centiliters and milliliters to liters)', () {
      final fromCl = UnitRegistry.convert(
        value: Decimal.fromInt(33),
        fromUnit: UnitRegistry.centiliter,
        toUnit: UnitRegistry.liter,
      );
      expect(fromCl, Decimal.parse('0.33'));

      final fromMl = UnitRegistry.convert(
        value: Decimal.fromInt(250),
        fromUnit: UnitRegistry.milliliter,
        toUnit: UnitRegistry.liter,
      );
      expect(fromMl, Decimal.parse('0.25'));
    });

    test('converts count correctly (dozen to pieces)', () {
      final pieces = UnitRegistry.convert(
        value: Decimal.fromInt(2),
        fromUnit: UnitRegistry.dozen,
        toUnit: UnitRegistry.piece,
      );
      expect(pieces, Decimal.fromInt(24));
    });

    test('normalizes mass and volume to base units (kg, L)', () {
      final massNorm = UnitRegistry.normalizeToBase(
        quantity: Decimal.fromInt(1500),
        unit: UnitRegistry.gram,
      );
      expect(massNorm?.normalizedQuantity, Decimal.parse('1.5'));
      expect(massNorm?.normalizedUnitSymbol, 'kg');

      final volNorm = UnitRegistry.normalizeToBase(
        quantity: Decimal.fromInt(75),
        unit: UnitRegistry.centiliter,
      );
      expect(volNorm?.normalizedQuantity, Decimal.parse('0.75'));
      expect(volNorm?.normalizedUnitSymbol, 'L');
    });
  });
}
