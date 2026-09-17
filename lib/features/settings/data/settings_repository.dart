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
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftSettingsRepository(db);
});

final userProfileProvider = StreamProvider<Profile?>((ref) {
  return ref.watch(settingsRepositoryProvider).watchProfile();
});
