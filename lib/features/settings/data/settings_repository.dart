import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

abstract class SettingsRepository {
  Stream<Profile?> watchProfile();
  Future<Profile?> getProfile();
  Future<void> updateMonthlyBudget(int budgetDzd);
  Future<void> updateLanguage(String langCode);
  Future<void> updateHouseholdSize(int? size);
  Future<String> exportDataAsJson();
  Future<String> exportPurchasesAsCsv();
  Future<bool> importDataFromJson(String jsonContent);

  // Erase Data methods
  Future<void> eraseAllData();
  Future<int> erasePurchasesAndActivity({DateTime? from, DateTime? to});
  Future<int> eraseLaterBuyItems({DateTime? from, DateTime? to});
  Future<int> eraseStores({List<String>? specificStoreIds, bool all = false});
  Future<int> eraseCustomFoods({List<String>? specificProductIds, bool all = false});
  Future<({int purchasesCount, int notesCount})> countPurchasesAndActivity({DateTime? from, DateTime? to});
  Future<int> countLaterBuyItems({DateTime? from, DateTime? to});
  Stream<List<Store>> watchAllStores();
  Stream<List<Product>> watchCustomProducts();
}

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Profile?> watchProfile() {
    return (_db.select(_db.profiles)..limit(1)).watchSingleOrNull();
  }

  @override
  Future<Profile?> getProfile() {
    return (_db.select(_db.profiles)..limit(1)).getSingleOrNull();
  }

  @override
  Future<void> updateMonthlyBudget(int budgetDzd) async {
    final profile = await getProfile();
    if (profile == null) return;
    await (_db.update(
      _db.profiles,
    )..where((t) => t.id.equals(profile.id))).write(
      ProfilesCompanion(
        monthlyBudgetDzd: Value(budgetDzd),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> updateLanguage(String langCode) async {
    final profile = await getProfile();
    if (profile == null) return;
    await (_db.update(
      _db.profiles,
    )..where((t) => t.id.equals(profile.id))).write(
      ProfilesCompanion(
        language: Value(langCode),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> updateHouseholdSize(int? size) async {
    final profile = await getProfile();
    if (profile == null) return;
    await (_db.update(
      _db.profiles,
    )..where((t) => t.id.equals(profile.id))).write(
      ProfilesCompanion(
        householdSize: Value(size),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<String> exportPurchasesAsCsv() async {
    final purchases = await (_db.select(
      _db.purchases,
    )..where((t) => t.deletedAt.isNull())).get();
    final products = await _db.select(_db.products).get();
    final productMap = {for (final p in products) p.id: p.name};

    final buffer = StringBuffer();
    buffer.writeln(
      'id,local_date,product_name,quantity,unit,price_dzd,total_dzd',
    );
    for (final p in purchases) {
      final name = productMap[p.productId] ?? 'Unknown';
      buffer.writeln(
        '${p.id},${p.localDate},"$name",${p.quantity},${p.unitId},${p.priceDzd},${p.totalDzd}',
      );
    }
    return buffer.toString();
  }

  @override
  Future<String> exportDataAsJson() async {
    final products = await (_db.select(_db.products)).get();
    final purchases = await (_db.select(_db.purchases)).get();
    final laterBuy = await (_db.select(_db.laterBuyItems)).get();
    final notes = await (_db.select(_db.notes)).get();

    final exportMap = {
      'version': '1.0.0',
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'products': products
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'brand': p.brand,
              'variant': p.variant,
              'lastPriceDzd': p.lastPriceDzd,
            },
          )
          .toList(),
      'purchases': purchases
          .map(
            (p) => {
              'id': p.id,
              'productId': p.productId,
              'quantity': p.quantity,
              'unitId': p.unitId,
              'totalDzd': p.totalDzd,
              'purchasedAt': p.purchasedAt.toIso8601String(),
              'localDate': p.localDate,
            },
          )
          .toList(),
      'laterBuy': laterBuy
          .map(
            (l) => {
              'id': l.id,
              'productId': l.productId,
              'observedPriceDzd': l.observedPriceDzd,
              'status': l.status,
            },
          )
          .toList(),
      'notes': notes
          .map(
            (n) => {
              'id': n.id,
              'title': n.title,
              'body': n.body,
              'noteType': n.noteType,
              'eventAt': n.eventAt.toIso8601String(),
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportMap);
  }

  @override
  Future<bool> importDataFromJson(String jsonContent) async {
    try {
      final map = jsonDecode(jsonContent) as Map<String, dynamic>;
      if (!map.containsKey('version')) return false;

      final products = (map['products'] as List?) ?? [];
      final purchases = (map['purchases'] as List?) ?? [];

      await _db.transaction(() async {
        for (final item in products) {
          final p = item as Map<String, dynamic>;
          final id = p['id'] as String;
          final existing = await (_db.select(
            _db.products,
          )..where((t) => t.id.equals(id))).getSingleOrNull();
          if (existing == null) {
            await _db
                .into(_db.products)
                .insert(
                  ProductsCompanion.insert(
                    id: id,
                    name: p['name'] as String,
                    normalizedName: (p['name'] as String).toLowerCase(),
                    brand: Value(p['brand'] as String?),
                    variant: Value(p['variant'] as String?),
                    lastPriceDzd: Value(p['lastPriceDzd'] as int?),
                    createdAt: DateTime.now().toUtc(),
                    updatedAt: DateTime.now().toUtc(),
                  ),
                );
          }
        }

        for (final item in purchases) {
          final pu = item as Map<String, dynamic>;
          final id = pu['id'] as String;
          final existing = await (_db.select(
            _db.purchases,
          )..where((t) => t.id.equals(id))).getSingleOrNull();
          if (existing == null) {
            final purchasedAt =
                DateTime.tryParse(pu['purchasedAt'] as String? ?? '') ??
                DateTime.now();
            await _db
                .into(_db.purchases)
                .insert(
                  PurchasesCompanion.insert(
                    id: id,
                    productId: pu['productId'] as String,
                    quantity: (pu['quantity'] as num).toDouble(),
                    unitId: pu['unitId'] as String? ?? 'piece',
                    priceDzd:
                        ((pu['totalDzd'] as num?)?.toInt() ?? 0) ~/
                        ((pu['quantity'] as num?)?.toDouble() ?? 1.0)
                            .clamp(1, 9999)
                            .toInt(),
                    totalDzd: (pu['totalDzd'] as num).toInt(),
                    purchasedAt: purchasedAt,
                    localDate:
                        pu['localDate'] as String? ??
                        purchasedAt.toIso8601String().substring(0, 10),
                  ),
                );
          }
        }
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  // --- Erase Data Implementation ---

  @override
  Future<void> eraseAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.notePurchaseLinks).go();
      await _db.delete(_db.noteProductLinks).go();
      await _db.delete(_db.noteTags).go();
      await _db.delete(_db.notes).go();
      await _db.delete(_db.shoppingListItems).go();
      await _db.delete(_db.shoppingLists).go();
      await _db.delete(_db.reminders).go();
      await _db.delete(_db.laterBuyItems).go();
      await _db.delete(_db.purchases).go();
      await _db.delete(_db.productAliases).go();
      await _db.delete(_db.productConversions).go();
      await (_db.delete(_db.products)
            ..where((t) =>
                t.id.like('premade_%').not() & t.id.like('sys_%').not()))
          .go();
      await _db.delete(_db.stores).go();
    });
  }

  @override
  Future<int> erasePurchasesAndActivity({DateTime? from, DateTime? to}) async {
    return await _db.transaction(() async {
      final purchaseQuery = _db.select(_db.purchases);
      if (from != null && to != null) {
        purchaseQuery.where((t) =>
            t.purchasedAt.isBiggerOrEqualValue(from) &
            t.purchasedAt.isSmallerOrEqualValue(to));
      } else if (from != null) {
        purchaseQuery.where((t) => t.purchasedAt.isBiggerOrEqualValue(from));
      } else if (to != null) {
        purchaseQuery.where((t) => t.purchasedAt.isSmallerOrEqualValue(to));
      }
      final purchasesToDelete = await purchaseQuery.get();
      final purchaseIds = purchasesToDelete.map((p) => p.id).toList();

      if (purchaseIds.isNotEmpty) {
        await (_db.delete(_db.notePurchaseLinks)
              ..where((t) => t.purchaseId.isIn(purchaseIds)))
            .go();
        await (_db.update(_db.laterBuyItems)
              ..where((t) => t.resolvedPurchaseId.isIn(purchaseIds)))
            .write(
          const LaterBuyItemsCompanion(resolvedPurchaseId: Value(null)),
        );
        await (_db.update(_db.shoppingListItems)
              ..where((t) => t.convertedPurchaseId.isIn(purchaseIds)))
            .write(
          const ShoppingListItemsCompanion(convertedPurchaseId: Value(null)),
        );
        await (_db.delete(_db.purchases)
              ..where((t) => t.id.isIn(purchaseIds)))
            .go();
      }

      final noteQuery = _db.select(_db.notes);
      if (from != null && to != null) {
        noteQuery.where((t) =>
            t.eventAt.isBiggerOrEqualValue(from) &
            t.eventAt.isSmallerOrEqualValue(to));
      } else if (from != null) {
        noteQuery.where((t) => t.eventAt.isBiggerOrEqualValue(from));
      } else if (to != null) {
        noteQuery.where((t) => t.eventAt.isSmallerOrEqualValue(to));
      }
      final notesToDelete = await noteQuery.get();
      final noteIds = notesToDelete.map((n) => n.id).toList();

      if (noteIds.isNotEmpty) {
        await (_db.delete(_db.noteTags)
              ..where((t) => t.noteId.isIn(noteIds)))
            .go();
        await (_db.delete(_db.noteProductLinks)
              ..where((t) => t.noteId.isIn(noteIds)))
            .go();
        await (_db.delete(_db.notePurchaseLinks)
              ..where((t) => t.noteId.isIn(noteIds)))
            .go();
        await (_db.delete(_db.notes)..where((t) => t.id.isIn(noteIds))).go();
      }

      return purchaseIds.length + noteIds.length;
    });
  }

  @override
  Future<int> eraseLaterBuyItems({DateTime? from, DateTime? to}) async {
    return await _db.transaction(() async {
      final query = _db.select(_db.laterBuyItems);
      if (from != null && to != null) {
        query.where((t) =>
            (t.createdAt.isBiggerOrEqualValue(from) &
                t.createdAt.isSmallerOrEqualValue(to)) |
            (t.resolvedAt.isNotNull() &
                t.resolvedAt.isBiggerOrEqualValue(from) &
                t.resolvedAt.isSmallerOrEqualValue(to)));
      } else if (from != null) {
        query.where((t) =>
            t.createdAt.isBiggerOrEqualValue(from) |
            (t.resolvedAt.isNotNull() &
                t.resolvedAt.isBiggerOrEqualValue(from)));
      } else if (to != null) {
        query.where((t) =>
            t.createdAt.isSmallerOrEqualValue(to) |
            (t.resolvedAt.isNotNull() &
                t.resolvedAt.isSmallerOrEqualValue(to)));
      }
      final items = await query.get();
      final ids = items.map((i) => i.id).toList();
      if (ids.isNotEmpty) {
        await (_db.delete(_db.reminders)
              ..where((t) =>
                  t.relatedType.equals('later_buy') & t.relatedId.isIn(ids)))
            .go();
        await (_db.delete(_db.laterBuyItems)
              ..where((t) => t.id.isIn(ids)))
            .go();
      }
      return ids.length;
    });
  }

  @override
  Future<int> eraseStores({
    List<String>? specificStoreIds,
    bool all = false,
  }) async {
    return await _db.transaction(() async {
      List<String> idsToDelete = [];
      if (all) {
        final allStores = await _db.select(_db.stores).get();
        idsToDelete = allStores.map((s) => s.id).toList();
      } else if (specificStoreIds != null && specificStoreIds.isNotEmpty) {
        idsToDelete = specificStoreIds;
      }
      if (idsToDelete.isEmpty) return 0;

      await (_db.update(_db.purchases)
            ..where((t) => t.storeId.isIn(idsToDelete)))
          .write(
        const PurchasesCompanion(storeId: Value(null)),
      );
      await (_db.update(_db.laterBuyItems)
            ..where((t) => t.storeId.isIn(idsToDelete)))
          .write(
        const LaterBuyItemsCompanion(storeId: Value(null)),
      );

      final count = await (_db.delete(_db.stores)
            ..where((t) => t.id.isIn(idsToDelete)))
          .go();
      return count;
    });
  }

  @override
  Future<int> eraseCustomFoods({
    List<String>? specificProductIds,
    bool all = false,
  }) async {
    return await _db.transaction(() async {
      List<String> idsToDelete = [];
      if (all) {
        final customProds = await (_db.select(_db.products)
              ..where((t) =>
                  t.id.like('premade_%').not() & t.id.like('sys_%').not()))
            .get();
        idsToDelete = customProds.map((p) => p.id).toList();
      } else if (specificProductIds != null && specificProductIds.isNotEmpty) {
        idsToDelete = specificProductIds;
      }
      if (idsToDelete.isEmpty) return 0;

      await (_db.delete(_db.noteProductLinks)
            ..where((t) => t.productId.isIn(idsToDelete)))
          .go();
      await (_db.delete(_db.productAliases)
            ..where((t) => t.productId.isIn(idsToDelete)))
          .go();
      await (_db.delete(_db.productConversions)
            ..where((t) => t.productId.isIn(idsToDelete)))
          .go();
      await (_db.delete(_db.shoppingListItems)
            ..where((t) => t.productId.isIn(idsToDelete)))
          .go();

      final laterBuys = await (_db.select(_db.laterBuyItems)
            ..where((t) => t.productId.isIn(idsToDelete)))
          .get();
      final laterBuyIds = laterBuys.map((l) => l.id).toList();
      if (laterBuyIds.isNotEmpty) {
        await (_db.delete(_db.reminders)
              ..where((t) =>
                  t.relatedType.equals('later_buy') &
                  t.relatedId.isIn(laterBuyIds)))
            .go();
        await (_db.delete(_db.laterBuyItems)
              ..where((t) => t.id.isIn(laterBuyIds)))
            .go();
      }

      final purchases = await (_db.select(_db.purchases)
            ..where((t) => t.productId.isIn(idsToDelete)))
          .get();
      final purchaseIds = purchases.map((p) => p.id).toList();
      if (purchaseIds.isNotEmpty) {
        await (_db.delete(_db.notePurchaseLinks)
              ..where((t) => t.purchaseId.isIn(purchaseIds)))
            .go();
        await (_db.delete(_db.purchases)
              ..where((t) => t.id.isIn(purchaseIds)))
            .go();
      }

      final count = await (_db.delete(_db.products)
            ..where((t) => t.id.isIn(idsToDelete)))
          .go();
      return count;
    });
  }

  @override
  Future<({int purchasesCount, int notesCount})> countPurchasesAndActivity({
    DateTime? from,
    DateTime? to,
  }) async {
    final purchaseQuery = _db.select(_db.purchases);
    if (from != null && to != null) {
      purchaseQuery.where((t) =>
          t.purchasedAt.isBiggerOrEqualValue(from) &
          t.purchasedAt.isSmallerOrEqualValue(to));
    } else if (from != null) {
      purchaseQuery.where((t) => t.purchasedAt.isBiggerOrEqualValue(from));
    } else if (to != null) {
      purchaseQuery.where((t) => t.purchasedAt.isSmallerOrEqualValue(to));
    }
    final purchases = await purchaseQuery.get();

    final noteQuery = _db.select(_db.notes);
    if (from != null && to != null) {
      noteQuery.where((t) =>
          t.eventAt.isBiggerOrEqualValue(from) &
          t.eventAt.isSmallerOrEqualValue(to));
    } else if (from != null) {
      noteQuery.where((t) => t.eventAt.isBiggerOrEqualValue(from));
    } else if (to != null) {
      noteQuery.where((t) => t.eventAt.isSmallerOrEqualValue(to));
    }
    final notes = await noteQuery.get();

    return (purchasesCount: purchases.length, notesCount: notes.length);
  }

  @override
  Future<int> countLaterBuyItems({DateTime? from, DateTime? to}) async {
    final query = _db.select(_db.laterBuyItems);
    if (from != null && to != null) {
      query.where((t) =>
          (t.createdAt.isBiggerOrEqualValue(from) &
              t.createdAt.isSmallerOrEqualValue(to)) |
          (t.resolvedAt.isNotNull() &
              t.resolvedAt.isBiggerOrEqualValue(from) &
              t.resolvedAt.isSmallerOrEqualValue(to)));
    } else if (from != null) {
      query.where((t) =>
          t.createdAt.isBiggerOrEqualValue(from) |
          (t.resolvedAt.isNotNull() &
              t.resolvedAt.isBiggerOrEqualValue(from)));
    } else if (to != null) {
      query.where((t) =>
          t.createdAt.isSmallerOrEqualValue(to) |
          (t.resolvedAt.isNotNull() &
              t.resolvedAt.isSmallerOrEqualValue(to)));
    }
    final items = await query.get();
    return items.length;
  }

  @override
  Stream<List<Store>> watchAllStores() {
    return (_db.select(_db.stores)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  @override
  Stream<List<Product>> watchCustomProducts() {
    return (_db.select(_db.products)
          ..where((t) =>
              t.deletedAt.isNull() &
              t.id.like('premade_%').not() &
              t.id.like('sys_%').not())
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftSettingsRepository(db);
});

final userProfileProvider = StreamProvider<Profile?>((ref) {
  return ref.watch(settingsRepositoryProvider).watchProfile();
});

final eraseStoresProvider = StreamProvider<List<Store>>((ref) {
  return ref.watch(settingsRepositoryProvider).watchAllStores();
});

final eraseCustomProductsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(settingsRepositoryProvider).watchCustomProducts();
});
