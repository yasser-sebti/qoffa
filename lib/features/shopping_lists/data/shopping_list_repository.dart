import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

abstract class ShoppingListRepository {
  Stream<List<ShoppingList>> watchActiveLists();
  Stream<List<ShoppingListItem>> watchListItems(String listId);
  Future<ShoppingList> createList({required String title});
  Future<ShoppingListItem> addItem({
    required String listId,
    required String customName,
    String? productId,
    double quantity = 1.0,
    String unitId = 'piece',
    int? estimatedPriceDzd,
  });
  Future<void> toggleItemCompleted(String itemId, bool isCompleted);
  Future<void> updateItemQuantity(String itemId, double quantity);
  Future<void> deleteItem(String itemId);
  Future<ShoppingList> getOrCreateDefaultList({String title = 'Shopping list'});
  Stream<List<DepartmentShoppingItem>> watchDepartmentShoppingItems(String listId);
}

class DepartmentShoppingItem {
  const DepartmentShoppingItem({
    required this.item,
    this.productId,
    this.categoryId,
    required this.categoryName,
    required this.categoryColorHex,
    required this.categoryIconKey,
    required this.unitPriceDzd,
  });

  final ShoppingListItem item;
  final String? productId;
  final String? categoryId;
  final String categoryName;
  final String categoryColorHex;
  final String categoryIconKey;
  final int unitPriceDzd;

  int get estimatedTotalDzd => (unitPriceDzd * item.quantity).round();
}

class DriftShoppingListRepository implements ShoppingListRepository {
  DriftShoppingListRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Stream<List<ShoppingList>> watchActiveLists() {
    return (_db.select(_db.shoppingLists)
          ..where((t) => t.deletedAt.isNull() & t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  @override
  Stream<List<ShoppingListItem>> watchListItems(String listId) {
    return (_db.select(
      _db.shoppingListItems,
    )..where((t) => t.listId.equals(listId))).watch();
  }

  @override
  Future<ShoppingList> createList({required String title}) async {
    final now = DateTime.now().toUtc();
    final entry = ShoppingListsCompanion.insert(
      id: _uuid.v4(),
      title: title.trim(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.shoppingLists).insert(entry);
    return (_db.select(
      _db.shoppingLists,
    )..where((t) => t.id.equals(entry.id.value))).getSingle();
  }

  @override
  Future<ShoppingListItem> addItem({
    required String listId,
    required String customName,
    String? productId,
    double quantity = 1.0,
    String unitId = 'piece',
    int? estimatedPriceDzd,
  }) async {
    final entry = ShoppingListItemsCompanion.insert(
      id: _uuid.v4(),
      listId: listId,
      customName: customName.trim(),
      productId: Value(productId),
      quantity: Value(quantity),
      unitId: Value(unitId),
      estimatedPriceDzd: Value(estimatedPriceDzd),
    );
    await _db.into(_db.shoppingListItems).insert(entry);
    // Touch list updatedAt
    await (_db.update(
      _db.shoppingLists,
    )..where((t) => t.id.equals(listId))).write(
      ShoppingListsCompanion(updatedAt: Value(DateTime.now().toUtc())),
    );
    return (_db.select(
      _db.shoppingListItems,
    )..where((t) => t.id.equals(entry.id.value))).getSingle();
  }

  @override
  Future<void> toggleItemCompleted(String itemId, bool isCompleted) async {
    await (_db.update(_db.shoppingListItems)..where((t) => t.id.equals(itemId)))
        .write(ShoppingListItemsCompanion(isCompleted: Value(isCompleted)));
  }

  @override
  Future<void> updateItemQuantity(String itemId, double quantity) async {
    await (_db.update(_db.shoppingListItems)..where((t) => t.id.equals(itemId)))
        .write(ShoppingListItemsCompanion(quantity: Value(quantity)));
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await (_db.delete(
      _db.shoppingListItems,
    )..where((t) => t.id.equals(itemId))).go();
  }

  @override
  Future<ShoppingList> getOrCreateDefaultList({
    String title = 'Shopping list',
  }) async {
    final existing =
        await (_db.select(_db.shoppingLists)
              ..where((t) => t.deletedAt.isNull() & t.isArchived.equals(false))
              ..limit(1))
            .getSingleOrNull();

    if (existing != null) return existing;
    return createList(title: title);
  }

  @override
  Stream<List<DepartmentShoppingItem>> watchDepartmentShoppingItems(String listId) {
    final itemsStream = watchListItems(listId);
    return itemsStream.asyncMap((items) async {
      final products = await (_db.select(_db.products)
            ..where((t) => t.deletedAt.isNull()))
          .get();
      final categories = await (_db.select(_db.categories)
            ..where((t) => t.deletedAt.isNull()))
          .get();
      final productMap = {for (final p in products) p.id: p};
      final categoryMap = {for (final c in categories) c.id: c};

      return items.map((item) {
        Product? product;
        if (item.productId != null) {
          product = productMap[item.productId];
        } else {
          final lower = item.customName.trim().toLowerCase();
          for (final p in products) {
            if (p.name.toLowerCase() == lower) {
              product = p;
              break;
            }
          }
        }

        final category = product?.categoryId != null
            ? categoryMap[product!.categoryId]
            : null;
        final categoryName = category?.nameAr ?? 'بقالة ومواد عامة';
        final categoryColorHex = category?.colorHex ?? '#0877EC';
        final categoryIconKey = category?.iconKey ?? 'basket';
        final unitPrice = item.estimatedPriceDzd ?? product?.lastPriceDzd ?? 0;

        return DepartmentShoppingItem(
          item: item,
          productId: product?.id,
          categoryId: category?.id,
          categoryName: categoryName,
          categoryColorHex: categoryColorHex,
          categoryIconKey: categoryIconKey,
          unitPriceDzd: unitPrice,
        );
      }).toList();
    });
  }
}

final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftShoppingListRepository(db);
});

final activeShoppingListsProvider = StreamProvider<List<ShoppingList>>((ref) {
  return ref.watch(shoppingListRepositoryProvider).watchActiveLists();
});

final shoppingListItemsProvider =
    StreamProvider.family<List<ShoppingListItem>, String>((ref, listId) {
      return ref.watch(shoppingListRepositoryProvider).watchListItems(listId);
    });

final departmentShoppingItemsProvider =
    StreamProvider.family<List<DepartmentShoppingItem>, String>((ref, listId) {
      return ref
          .watch(shoppingListRepositoryProvider)
          .watchDepartmentShoppingItems(listId);
    });

