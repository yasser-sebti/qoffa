import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../purchases/data/purchase_repository.dart';

abstract class LaterBuyRepository {
  Stream<List<LaterBuyItem>> watchItemsByStatus(String status);
  Stream<int> watchPendingCount();
  Future<LaterBuyItem?> findActiveItemForProduct(String productId);
  Future<LaterBuyItem> createLaterBuyItem({
    required String productId,
    required int observedPriceDzd,
    required double observedQuantity,
    required String observedUnitId,
    int? targetPriceDzd,
    String? storeId,
    String reason = 'expensive',
    DateTime? reminderAt,
  });
  Future<void> updateStatus(String id, String newStatus);
  Future<void> resolveAsBought({
    required String laterBuyId,
    required double quantity,
    required String unitId,
    required int finalPriceDzd,
    required bool isUnitPrice,
    required DateTime purchasedAt,
    String? storeId,
  });
}

class DriftLaterBuyRepository implements LaterBuyRepository {
  DriftLaterBuyRepository(this._db, this._purchaseRepo);

  final AppDatabase _db;
  final PurchaseRepository _purchaseRepo;
  static const _uuid = Uuid();

  @override
  Stream<List<LaterBuyItem>> watchItemsByStatus(String status) {
    return (_db.select(_db.laterBuyItems)
          ..where((t) => t.status.equals(status) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  @override
  Stream<int> watchPendingCount() {
    return (_db.select(_db.laterBuyItems)
          ..where((t) => t.status.equals('active') & t.deletedAt.isNull()))
        .watch()
        .map((items) => items.length);
  }

  @override
  Future<LaterBuyItem?> findActiveItemForProduct(String productId) {
    return (_db.select(_db.laterBuyItems)
          ..where((t) =>
              t.productId.equals(productId) &
              t.status.equals('active') &
              t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  @override
  Future<LaterBuyItem> createLaterBuyItem({
    required String productId,
    required int observedPriceDzd,
    required double observedQuantity,
    required String observedUnitId,
    int? targetPriceDzd,
    String? storeId,
    String reason = 'expensive',
    DateTime? reminderAt,
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();

    final companion = LaterBuyItemsCompanion.insert(
      id: id,
      productId: productId,
      observedPriceDzd: observedPriceDzd,
      observedQuantity: observedQuantity,
      observedUnitId: observedUnitId,
      targetPriceDzd: Value(targetPriceDzd),
      storeId: Value(storeId),
      reason: Value(reason),
      status: const Value('active'),
      reminderAt: Value(reminderAt),
      createdAt: now,
      updatedAt: now,
    );

    await _db.into(_db.laterBuyItems).insert(companion);
    return (await (_db.select(_db.laterBuyItems)..where((t) => t.id.equals(id))).getSingle());
  }

  @override
  Future<void> updateStatus(String id, String newStatus) async {
    await (_db.update(_db.laterBuyItems)..where((t) => t.id.equals(id))).write(
      LaterBuyItemsCompanion(
        status: Value(newStatus),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> resolveAsBought({
    required String laterBuyId,
    required double quantity,
    required String unitId,
    required int finalPriceDzd,
    required bool isUnitPrice,
    required DateTime purchasedAt,
    String? storeId,
  }) async {
    final item = await (_db.select(_db.laterBuyItems)
          ..where((t) => t.id.equals(laterBuyId)))
        .getSingleOrNull();
    if (item == null) return;

    await _db.transaction(() async {
      // 1. Create Purchase
      final purchase = await _purchaseRepo.createPurchase(
        productId: item.productId,
        quantity: quantity,
        unitId: unitId,
        priceDzd: finalPriceDzd,
        isUnitPrice: isUnitPrice,
        purchasedAt: purchasedAt,
        storeId: storeId ?? item.storeId,
      );

      // 2. Mark Later Buy item as bought and link purchase
      await (_db.update(_db.laterBuyItems)..where((t) => t.id.equals(laterBuyId))).write(
        LaterBuyItemsCompanion(
          status: const Value('bought'),
          resolvedPurchaseId: Value(purchase.id),
          resolvedAt: Value(DateTime.now().toUtc()),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    });
  }
}

final laterBuyRepositoryProvider = Provider<LaterBuyRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final purchaseRepo = ref.watch(purchaseRepositoryProvider);
  return DriftLaterBuyRepository(db, purchaseRepo);
});
