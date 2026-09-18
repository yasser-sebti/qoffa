import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/search/search_normalizer.dart';

enum MarketSortOption {
  dateDesc,
  priceAsc,
  priceDesc,
  mostBought,
  alphabetical,
}

class MarketPriceItem {
  const MarketPriceItem({
    required this.productId,
    required this.productName,
    this.brand,
    this.barcode,
    this.categoryId,
    required this.categoryName,
    this.categoryNameEn,
    this.categoryNameFr,
    required this.categoryColorHex,
    required this.categoryIconKey,
    required this.preferredUnitId,
    required this.latestPriceDzd,
    required this.latestPurchasedAt,
    this.latestStoreId,
    this.latestStoreName,
    this.minPriceDzd,
    this.cheapestStoreName,
    this.previousPriceDzd,
    this.purchaseCount = 0,
  });

  final String productId;
  final String productName;
  final String? brand;
  final String? barcode;
  final String? categoryId;
  final String categoryName;
  final String? categoryNameEn;
  final String? categoryNameFr;
  final String categoryColorHex;
  final String categoryIconKey;
  final String preferredUnitId;
  final int latestPriceDzd;
  final DateTime latestPurchasedAt;
  final String? latestStoreId;
  final String? latestStoreName;
  final int? minPriceDzd;
  final String? cheapestStoreName;
  final int? previousPriceDzd;
  final int purchaseCount;

  /// Returns the localized category name based on language code ('ar', 'fr', 'en')
  String localizedCategoryName(String langCode) {
    if (langCode == 'fr' && (categoryNameFr?.trim().isNotEmpty ?? false)) {
      return categoryNameFr!;
    }
    if (langCode == 'en' && (categoryNameEn?.trim().isNotEmpty ?? false)) {
      return categoryNameEn!;
    }
    return categoryName;
  }

  /// Price change vs previously recorded price. Positive means price rose, negative means price dropped.
  int? get priceDiff {
    if (previousPriceDzd == null || latestPriceDzd == 0) return null;
    return latestPriceDzd - previousPriceDzd!;
  }

  /// Whether this item is from the premade/uploaded system catalog (name locked).
  bool get isPremade =>
      productId.startsWith('premade_') || productId.startsWith('sys_');
}

class MarketFilterState {
  const MarketFilterState({
    this.searchQuery = '',
    this.selectedCategoryId,
    this.selectedStoreId,
    this.minPrice,
    this.maxPrice,
    this.sortOption = MarketSortOption.dateDesc,
  });

  final String searchQuery;
  final String? selectedCategoryId;
  final String? selectedStoreId;
  final int? minPrice;
  final int? maxPrice;
  final MarketSortOption sortOption;

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      selectedStoreId != null ||
      minPrice != null ||
      maxPrice != null;

  int get activeFilterCount {
    int count = 0;
    if (selectedCategoryId != null) count++;
    if (selectedStoreId != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    return count;
  }

  MarketFilterState copyWith({
    String? searchQuery,
    String? Function()? selectedCategoryId,
    String? Function()? selectedStoreId,
    int? Function()? minPrice,
    int? Function()? maxPrice,
    MarketSortOption? sortOption,
  }) {
    return MarketFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      selectedStoreId: selectedStoreId != null
          ? selectedStoreId()
          : this.selectedStoreId,
      minPrice: minPrice != null ? minPrice() : this.minPrice,
      maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

abstract class MarketPriceRepository {
  Stream<List<MarketPriceItem>> watchMarketPriceDirectory();
  Stream<List<Category>> watchCategories();
  Stream<List<Store>> watchStores();
  Future<void> addFoodItem({
    required String name,
    required String categoryId,
    required int priceDzd,
    String? storeId,
    String unitId = 'piece',
  });
  Future<void> updateFoodItemPriceAndStore({
    required String productId,
    required int priceDzd,
    String? storeId,
    String? name,
  });
  Future<void> removeFoodItem(String productId);
  Future<void> syncMarketData();
}

class DriftMarketPriceRepository implements MarketPriceRepository {
  DriftMarketPriceRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> addFoodItem({
    required String name,
    required String categoryId,
    required int priceDzd,
    String? storeId,
    String unitId = 'piece',
  }) async {
    final now = DateTime.now().toUtc();
    final cleanName = name.trim();
    final prodId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    await _db.into(_db.products).insert(
      ProductsCompanion.insert(
        id: prodId,
        name: cleanName,
        normalizedName: cleanName.toLowerCase(),
        categoryId: Value(categoryId),
        lastPriceDzd: Value(priceDzd),
        preferredUnitId: Value(unitId),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await _db.into(_db.purchases).insert(
      PurchasesCompanion.insert(
        id: 'purch_${DateTime.now().millisecondsSinceEpoch}',
        productId: prodId,
        storeId: Value(storeId),
        quantity: 1,
        unitId: unitId,
        priceDzd: priceDzd,
        totalDzd: priceDzd,
        purchasedAt: now,
        localDate:
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      ),
    );
  }

  @override
  Future<void> updateFoodItemPriceAndStore({
    required String productId,
    required int priceDzd,
    String? storeId,
    String? name,
  }) async {
    final now = DateTime.now().toUtc();
    final cleanName = name?.trim();
    await (_db.update(_db.products)..where((t) => t.id.equals(productId))).write(
      ProductsCompanion(
        lastPriceDzd: Value(priceDzd),
        updatedAt: Value(now),
        name: cleanName != null && cleanName.isNotEmpty ? Value(cleanName) : const Value.absent(),
        normalizedName: cleanName != null && cleanName.isNotEmpty
            ? Value(cleanName.toLowerCase())
            : const Value.absent(),
      ),
    );
    final product = await (_db.select(_db.products)
          ..where((t) => t.id.equals(productId)))
        .getSingleOrNull();
    final unit = product?.preferredUnitId ?? 'piece';
    await _db.into(_db.purchases).insert(
      PurchasesCompanion.insert(
        id: 'purch_${DateTime.now().millisecondsSinceEpoch}',
        productId: productId,
        storeId: Value(storeId),
        quantity: 1,
        unitId: unit,
        priceDzd: priceDzd,
        totalDzd: priceDzd,
        purchasedAt: now,
        localDate:
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      ),
    );
  }

  @override
  Future<void> removeFoodItem(String productId) async {
    final now = DateTime.now().toUtc();
    await (_db.update(_db.products)..where((t) => t.id.equals(productId))).write(
      ProductsCompanion(deletedAt: Value(now)),
    );
  }

  @override
  Future<void> syncMarketData() async {
    // Simulates / prepares the future cloud synchronization of premade food catalog
    final now = DateTime.now().toUtc();
    final existing = await (_db.select(_db.products)
          ..where((t) => t.id.like('premade_%')))
        .get();
    if (existing.isEmpty) {
      // Seed foundational Algerian grocery items as premade data
      final staples = [
        (
          id: 'premade_milk',
          name: 'حليب كانديا 1 لتر',
          cat: 'cat_dairy',
          price: 135,
          unit: 'piece',
        ),
        (
          id: 'premade_oil',
          name: 'زيت المائدة إيليو 5 لتر',
          cat: 'cat_pantry',
          price: 650,
          unit: 'piece',
        ),
        (
          id: 'premade_tomatoes',
          name: 'طماطم طازجة',
          cat: 'cat_produce',
          price: 120,
          unit: 'kg',
        ),
        (
          id: 'premade_potatoes',
          name: 'بطاطا محلية',
          cat: 'cat_produce',
          price: 80,
          unit: 'kg',
        ),
        (
          id: 'premade_meat',
          name: 'لحم خروف محلي',
          cat: 'cat_meat',
          price: 2400,
          unit: 'kg',
        ),
        (
          id: 'premade_chicken',
          name: 'دجاج طازج',
          cat: 'cat_meat',
          price: 460,
          unit: 'kg',
        ),
        (
          id: 'premade_bread',
          name: 'خبز باقيت طازج',
          cat: 'cat_bakery',
          price: 15,
          unit: 'piece',
        ),
        (
          id: 'premade_water',
          name: 'ماء معدني لالة خديجة 1.5 لتر',
          cat: 'cat_beverages',
          price: 45,
          unit: 'piece',
        ),
      ];

      for (final s in staples) {
        await _db.into(_db.products).insertOnConflictUpdate(
          ProductsCompanion.insert(
            id: s.id,
            name: s.name,
            normalizedName: s.name.toLowerCase(),
            categoryId: Value(s.cat),
            lastPriceDzd: Value(s.price),
            preferredUnitId: Value(s.unit),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
    }
  }

  @override
  Stream<List<Category>> watchCategories() {
    return (_db.select(_db.categories)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  @override
  Stream<List<Store>> watchStores() {
    return (_db.select(_db.stores)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  @override
  Stream<List<MarketPriceItem>> watchMarketPriceDirectory() {
    // We reactively combine products, categories, purchases, and stores
    final productsStream = (_db.select(_db.products)
          ..where((t) => t.deletedAt.isNull() & t.isArchived.equals(false)))
        .watch();

    return productsStream.asyncMap((products) async {
      final categories = await (_db.select(_db.categories)
            ..where((t) => t.deletedAt.isNull()))
          .get();
      final purchases = await (_db.select(_db.purchases)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.purchasedAt)]))
          .get();
      final stores = await (_db.select(_db.stores)
            ..where((t) => t.deletedAt.isNull()))
          .get();

      final categoryMap = {for (final c in categories) c.id: c};
      final storeMap = {for (final s in stores) s.id: s.name};

      // Group purchases by productId
      final purchasesByProduct = <String, List<Purchase>>{};
      for (final p in purchases) {
        purchasesByProduct.putIfAbsent(p.productId, () => []).add(p);
      }

      final items = <MarketPriceItem>[];

      for (final product in products) {
        final category = categoryMap[product.categoryId];
        final prodPurchases = purchasesByProduct[product.id] ?? const [];

        int latestPrice = product.lastPriceDzd ?? 0;
        DateTime latestDate = product.updatedAt;
        String? latestStoreId;
        String? latestStoreName;
        int? previousPrice;
        int? minPrice;
        String? cheapestStoreName;

        if (prodPurchases.isNotEmpty) {
          final firstPurchase = prodPurchases.first;
          latestPrice = firstPurchase.priceDzd;
          latestDate = firstPurchase.purchasedAt;
          latestStoreId = firstPurchase.storeId;
          latestStoreName = latestStoreId != null ? storeMap[latestStoreId] : null;

          if (prodPurchases.length > 1) {
            previousPrice = prodPurchases[1].priceDzd;
          }

          // Find lowest recorded price across all purchases
          Purchase lowest = prodPurchases.first;
          for (final p in prodPurchases) {
            if (p.priceDzd > 0 && (lowest.priceDzd <= 0 || p.priceDzd < lowest.priceDzd)) {
              lowest = p;
            }
          }
          if (lowest.priceDzd > 0) {
            minPrice = lowest.priceDzd;
            cheapestStoreName =
                lowest.storeId != null ? storeMap[lowest.storeId] : null;
          }
        }

        final categoryName = category?.nameAr ?? 'أخرى';
        final categoryNameEn = category?.nameEn ?? 'Other';
        final categoryNameFr = category?.nameFr ?? 'Autre';
        final categoryColorHex = category?.colorHex ?? '#0AA343';
        final categoryIconKey = category?.iconKey ?? 'basket';

        items.add(
          MarketPriceItem(
            productId: product.id,
            productName: product.name,
            brand: product.brand,
            barcode: product.barcode,
            categoryId: product.categoryId,
            categoryName: categoryName,
            categoryNameEn: categoryNameEn,
            categoryNameFr: categoryNameFr,
            categoryColorHex: categoryColorHex,
            categoryIconKey: categoryIconKey,
            preferredUnitId: product.preferredUnitId,
            latestPriceDzd: latestPrice,
            latestPurchasedAt: latestDate,
            latestStoreId: latestStoreId,
            latestStoreName: latestStoreName,
            minPriceDzd: minPrice,
            cheapestStoreName: cheapestStoreName,
            previousPriceDzd: previousPrice,
            purchaseCount: prodPurchases.length,
          ),
        );
      }

      return items;
    });
  }
}

final marketPriceRepositoryProvider = Provider<MarketPriceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftMarketPriceRepository(db);
});

final rawMarketItemsProvider = StreamProvider<List<MarketPriceItem>>((ref) {
  final repo = ref.watch(marketPriceRepositoryProvider);
  return repo.watchMarketPriceDirectory();
});

final marketCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(marketPriceRepositoryProvider);
  return repo.watchCategories();
});

final marketStoresProvider = StreamProvider<List<Store>>((ref) {
  final repo = ref.watch(marketPriceRepositoryProvider);
  return repo.watchStores();
});

final marketFilterProvider =
    StateProvider<MarketFilterState>((ref) => const MarketFilterState());

final filteredMarketItemsProvider = Provider<List<MarketPriceItem>>((ref) {
  final rawAsync = ref.watch(rawMarketItemsProvider);
  final items = rawAsync.value ?? const [];
  final filter = ref.watch(marketFilterProvider);

  var result = List<MarketPriceItem>.from(items);

  // Filter by category
  if (filter.selectedCategoryId != null) {
    result = result
        .where((item) => item.categoryId == filter.selectedCategoryId)
        .toList();
  }

  // Filter by store
  if (filter.selectedStoreId != null) {
    result = result
        .where((item) => item.latestStoreId == filter.selectedStoreId)
        .toList();
  }

  // Filter by price range
  if (filter.minPrice != null) {
    result = result
        .where((item) => item.latestPriceDzd >= filter.minPrice!)
        .toList();
  }
  if (filter.maxPrice != null) {
    result = result
        .where((item) => item.latestPriceDzd <= filter.maxPrice!)
        .toList();
  }

  // Filter by search query
  if (filter.searchQuery.trim().isNotEmpty) {
    final query = filter.searchQuery.trim();
    result = result.where((item) {
      final nameScore =
          SearchNormalizer.matchScore(query: query, target: item.productName);
      if (nameScore >= 0) return true;
      if (item.brand != null) {
        final brandScore =
            SearchNormalizer.matchScore(query: query, target: item.brand!);
        if (brandScore >= 0) return true;
      }
      if (item.barcode != null && item.barcode!.contains(query)) return true;
      return false;
    }).toList();
  }

  // Sort
  switch (filter.sortOption) {
    case MarketSortOption.priceAsc:
      result.sort((a, b) => a.latestPriceDzd.compareTo(b.latestPriceDzd));
      break;
    case MarketSortOption.priceDesc:
      result.sort((a, b) => b.latestPriceDzd.compareTo(a.latestPriceDzd));
      break;
    case MarketSortOption.dateDesc:
      result.sort((a, b) => b.latestPurchasedAt.compareTo(a.latestPurchasedAt));
      break;
    case MarketSortOption.mostBought:
      result.sort((a, b) => b.purchaseCount.compareTo(a.purchaseCount));
      break;
    case MarketSortOption.alphabetical:
      result.sort((a, b) => a.productName.compareTo(b.productName));
      break;
  }

  return result;
});
