import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

abstract class StoreRepository {
  Future<List<Store>> searchStores(String query);
  Future<List<Store>> getAllActiveStores();
  Future<Store?> getStoreById(String id);
  Future<List<Store>> getRecentStores({int limit = 5});
  Future<Store> createStore({
    required String name,
    String? area,
    String? storeType,
    int? rating,
  });
  Future<void> updateStore(Store store);
  Future<void> deleteStore(String id);
}

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return DriftStoreRepository(ref.watch(databaseProvider));
});

class DriftStoreRepository implements StoreRepository {
  DriftStoreRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Future<List<Store>> searchStores(String query) async {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return getAllActiveStores();
    }

    return (_db.select(_db.stores)
          ..where(
            (t) =>
                t.deletedAt.isNull() &
                (t.name.lower().contains(trimmed) |
                    t.area.lower().contains(trimmed)),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.name)])
          ..limit(20))
        .get();
  }

  @override
  Future<List<Store>> getAllActiveStores() async {
    return (_db.select(_db.stores)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  @override
  Future<Store?> getStoreById(String id) async {
    return (_db.select(_db.stores)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  @override
  Future<List<Store>> getRecentStores({int limit = 5}) async {
    // 1. Get recent store IDs from purchases
    final query = _db.select(_db.purchases).join([
      innerJoin(_db.stores, _db.stores.id.equalsExp(_db.purchases.storeId)),
    ])
      ..where(_db.purchases.deletedAt.isNull() & _db.stores.deletedAt.isNull())
      ..orderBy([OrderingTerm.desc(_db.purchases.purchasedAt)])
      ..limit(30);

    final rows = await query.get();
    final seenIds = <String>{};
    final recentStores = <Store>[];

    for (final row in rows) {
      final store = row.readTable(_db.stores);
      if (!seenIds.contains(store.id)) {
        seenIds.add(store.id);
        recentStores.add(store);
        if (recentStores.length >= limit) break;
      }
    }

    // If we have fewer than limit, supplement with most recently created/alphabetical stores
    if (recentStores.length < limit) {
      final all = await getAllActiveStores();
      for (final s in all) {
        if (!seenIds.contains(s.id)) {
          seenIds.add(s.id);
          recentStores.add(s);
          if (recentStores.length >= limit) break;
        }
      }
    }

    return recentStores;
  }

  @override
  Future<Store> createStore({
    required String name,
    String? area,
    String? storeType,
    int? rating,
  }) async {
    final id = _uuid.v4();
    final trimmedName = name.trim();
    final trimmedArea = area?.trim();
    final validArea = (trimmedArea != null && trimmedArea.isNotEmpty)
        ? trimmedArea
        : null;

    final storeCompanion = StoresCompanion.insert(
      id: id,
      name: trimmedName,
      area: Value(validArea),
      storeType: Value(storeType),
      rating: Value(rating),
      deletedAt: const Value.absent(),
    );

    await _db.into(_db.stores).insert(storeCompanion);
    return Store(
      id: id,
      name: trimmedName,
      area: validArea,
      storeType: storeType,
      rating: rating,
      deletedAt: null,
    );
  }

  @override
  Future<void> updateStore(Store store) async {
    await _db.update(_db.stores).replace(store);
  }

  @override
  Future<void> deleteStore(String id) async {
    await (_db.update(_db.stores)..where((t) => t.id.equals(id))).write(
      StoresCompanion(deletedAt: Value(DateTime.now().toUtc())),
    );
  }
}
