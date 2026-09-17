import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/money/dzd_amount.dart';
import '../../../core/units/unit_registry.dart';

abstract class PurchaseRepository {
  Stream<List<Purchase>> watchPurchasesForMonth(int year, int month);
  Stream<List<Purchase>> watchPurchasesForDate(String localDate);
  Stream<List<Purchase>> watchRecentPurchases({int limit = 10});
  Stream<DzdAmount> watchMonthlyTotal(int year, int month);
  Future<List<Purchase>> getPurchasesForProduct(String productId);
  Future<Purchase> createPurchase({
    required String productId,
    required double quantity,
    required String unitId,
    required int priceDzd,
    required bool isUnitPrice,
    required DateTime purchasedAt,
    String? storeId,
    String? note,
    DateTime? expiryDate,
  });
  Future<void> updatePurchase(Purchase purchase);
  Future<void> deletePurchase(String id);
}

class DriftPurchaseRepository implements PurchaseRepository {
  DriftPurchaseRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Stream<List<Purchase>> watchPurchasesForMonth(int year, int month) {
    final start = DateTime.utc(year, month, 1);
    final end = DateTime.utc(year, month + 1, 0, 23, 59, 59);

    return (_db.select(_db.purchases)
          ..where((t) =>
              t.purchasedAt.isBiggerOrEqualValue(start) &
              t.purchasedAt.isSmallerOrEqualValue(end) &
              t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.purchasedAt)]))
        .watch();
  }

  @override
  Stream<List<Purchase>> watchPurchasesForDate(String localDate) {
    return (_db.select(_db.purchases)
          ..where((t) => t.localDate.equals(localDate) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.purchasedAt)]))
        .watch();
  }

  @override
  Stream<List<Purchase>> watchRecentPurchases({int limit = 10}) {
    return (_db.select(_db.purchases)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.purchasedAt)])
          ..limit(limit))
        .watch();
  }

  @override
  Stream<DzdAmount> watchMonthlyTotal(int year, int month) {
    return watchPurchasesForMonth(year, month).map((purchases) {
      var total = 0;
      for (final p in purchases) {
        total += p.totalDzd;
      }
      return DzdAmount(total);
    });
  }

  @override
  Future<List<Purchase>> getPurchasesForProduct(String productId) {
    return (_db.select(_db.purchases)
          ..where((t) => t.productId.equals(productId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.purchasedAt)]))
        .get();
  }

  @override
  Future<Purchase> createPurchase({
    required String productId,
    required double quantity,
    required String unitId,
    required int priceDzd,
    required bool isUnitPrice,
    required DateTime purchasedAt,
    String? storeId,
    String? note,
    DateTime? expiryDate,
  }) async {
    final id = _uuid.v4();
    final dzdPrice = DzdAmount(priceDzd);
    final decQty = Decimal.parse(quantity.toString());

    // Calculate total DZD
    final totalDzd = isUnitPrice
        ? DzdAmount.fromUnitAndQuantity(unitPrice: dzdPrice, quantity: decQty).dinars
        : priceDzd;

    // Normalize base quantity
    final unit = UnitRegistry.fromIdOrFallback(unitId);
    final norm = UnitRegistry.normalizeToBase(quantity: decQty, unit: unit);
    final normBaseQty = norm?.normalizedQuantity.toDouble();
    final normRate = norm != null && norm.normalizedQuantity > Decimal.zero
        ? (Decimal.fromInt(totalDzd) / norm.normalizedQuantity).toDecimal(scaleOnInfinitePrecision: 4).toDouble()
        : null;

    final localDate = '${purchasedAt.year.toString().padLeft(4, '0')}-${purchasedAt.month.toString().padLeft(2, '0')}-${purchasedAt.day.toString().padLeft(2, '0')}';

    final purchaseCompanion = PurchasesCompanion.insert(
      id: id,
      productId: productId,
      storeId: Value(storeId),
      quantity: quantity,
      unitId: unitId,
      priceDzd: priceDzd,
      isUnitPrice: Value(isUnitPrice),
      totalDzd: totalDzd,
      normalizedBaseQuantity: Value(normBaseQty),
      normalizedDzdPerBaseUnit: Value(normRate),
      purchasedAt: purchasedAt,
      localDate: localDate,
      note: Value(note),
      expiryDate: Value(expiryDate),
    );

    // Transaction: Insert purchase and update product's last price and updated timestamp
    await _db.transaction(() async {
      await _db.into(_db.purchases).insert(purchaseCompanion);
      await (_db.update(_db.products)..where((t) => t.id.equals(productId))).write(
        ProductsCompanion(
          lastPriceDzd: Value(isUnitPrice ? priceDzd : (totalDzd ~/ quantity).toInt()),
          preferredUnitId: Value(unitId),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    });

    return (await (_db.select(_db.purchases)..where((t) => t.id.equals(id))).getSingle());
  }

  @override
  Future<void> updatePurchase(Purchase purchase) async {
    await (_db.update(_db.purchases)..where((t) => t.id.equals(purchase.id)))
        .write(purchase);
  }

  @override
  Future<void> deletePurchase(String id) async {
    await (_db.update(_db.purchases)..where((t) => t.id.equals(id))).write(
      PurchasesCompanion(
        deletedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftPurchaseRepository(db);
});
