import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/search/search_normalizer.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchAllProducts();
  Future<List<Product>> searchProducts(String query);
  Future<Product?> getProductById(String id);
  Future<Product?> findByBarcode(String barcode);
  Future<Product> createProduct({
    required String name,
    String? brand,
    String? variant,
    String? barcode,
    String? categoryId,
    String preferredUnitId = 'kg',
    double? packageQuantity,
    String? packageUnitId,
    int? initialPriceDzd,
    List<String> aliases = const [],
  });
  Future<void> updateProduct(Product product);
  Future<void> softDeleteProduct(String id);
  Future<List<Product>> getFrequentProducts({int limit = 10});
}

class DriftProductRepository implements ProductRepository {
  DriftProductRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Stream<List<Product>> watchAllProducts() {
    return (_db.select(_db.products)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) {
      return (_db.select(_db.products)
            ..where((t) => t.deletedAt.isNull())
            ..limit(20))
          .get();
    }

    final all = await (_db.select(
      _db.products,
    )..where((t) => t.deletedAt.isNull())).get();

    final aliases = await (_db.select(_db.productAliases)).get();
    final aliasMap = <String, List<String>>{};
    for (final a in aliases) {
      aliasMap.putIfAbsent(a.productId, () => []).add(a.alias);
    }

    final scored = <({Product product, int score})>[];

    for (final p in all) {
      var score = SearchNormalizer.matchScore(query: clean, target: p.name);
      if (p.brand != null) {
        final bScore = SearchNormalizer.matchScore(
          query: clean,
          target: p.brand!,
        );
        if (bScore > score) score = bScore;
      }
      final productAliases = aliasMap[p.id] ?? [];
      for (final a in productAliases) {
        final aScore = SearchNormalizer.matchScore(query: clean, target: a);
        if (aScore > score) score = aScore;
      }

      if (score >= 0) {
        scored.add((product: p, score: score));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.map((s) => s.product).toList();
  }

  @override
  Future<Product?> getProductById(String id) {
    return (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<Product?> findByBarcode(String barcode) {
    return (_db.select(_db.products)
          ..where((t) => t.barcode.equals(barcode) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  @override
  Future<Product> createProduct({
    required String name,
    String? brand,
    String? variant,
    String? barcode,
    String? categoryId,
    String preferredUnitId = 'kg',
    double? packageQuantity,
    String? packageUnitId,
    int? initialPriceDzd,
    List<String> aliases = const [],
  }) async {
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final normalized = SearchNormalizer.normalize(name);

    final productCompanion = ProductsCompanion.insert(
      id: id,
      name: name,
      normalizedName: normalized,
      brand: Value(brand),
      variant: Value(variant),
      barcode: Value(barcode),
      categoryId: Value(categoryId),
      preferredUnitId: Value(preferredUnitId),
      packageQuantity: Value(packageQuantity),
      packageUnitId: Value(packageUnitId),
      lastPriceDzd: Value(initialPriceDzd),
      createdAt: now,
      updatedAt: now,
    );

    await _db.into(_db.products).insert(productCompanion);

    // Insert aliases
    for (final alias in aliases) {
      if (alias.trim().isNotEmpty) {
        await _db
            .into(_db.productAliases)
            .insert(
              ProductAliasesCompanion.insert(
                id: _uuid.v4(),
                productId: id,
                alias: alias.trim(),
                normalizedAlias: SearchNormalizer.normalize(alias),
              ),
            );
      }
    }

    return (await getProductById(id))!;
  }

  @override
  Future<void> updateProduct(Product product) async {
    await (_db.update(
      _db.products,
    )..where((t) => t.id.equals(product.id))).write(
      product.copyWith(
        normalizedName: SearchNormalizer.normalize(product.name),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<void> softDeleteProduct(String id) async {
    await (_db.update(_db.products)..where((t) => t.id.equals(id))).write(
      ProductsCompanion(deletedAt: Value(DateTime.now().toUtc())),
    );
  }

  @override
  Future<List<Product>> getFrequentProducts({int limit = 10}) async {
    // Return most recently created/used products
    return (_db.select(_db.products)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(limit))
        .get();
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftProductRepository(db);
});
