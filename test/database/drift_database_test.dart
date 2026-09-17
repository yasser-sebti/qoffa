import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/features/later_buy/data/later_buy_repository.dart';
import 'package:qoffa/features/notebook/data/notebook_repository.dart';
import 'package:qoffa/features/products/data/product_repository.dart';
import 'package:qoffa/features/purchases/data/purchase_repository.dart';
import 'package:qoffa/features/settings/data/settings_repository.dart';
import 'package:qoffa/features/shopping_lists/data/shopping_list_repository.dart';

void main() {
  late AppDatabase db;
  late DriftProductRepository productRepo;
  late DriftPurchaseRepository purchaseRepo;
  late DriftLaterBuyRepository laterBuyRepo;
  late DriftNotebookRepository notebookRepo;
  late DriftSettingsRepository settingsRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    productRepo = DriftProductRepository(db);
    purchaseRepo = DriftPurchaseRepository(db);
    laterBuyRepo = DriftLaterBuyRepository(db, purchaseRepo);
    notebookRepo = DriftNotebookRepository(db);
    settingsRepo = DriftSettingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Local-Only Database Integration', () {
    test('initializes with default profile and initial seeded categories', () async {
      final profile = await settingsRepo.getProfile();
      expect(profile, isNotNull);
      expect(profile!.language, 'ar');
      expect(profile.monthlyBudgetDzd, 60000);

      final categories = await db.select(db.categories).get();
      expect(categories, isNotEmpty);
      expect(categories.any((c) => c.nameEn.contains('Dairy')), isTrue);
    });

    test('creates and retrieves products with resilient search', () async {
      final product = await productRepo.createProduct(
        name: 'Lait Candia 1L',
        brand: 'Candia',
        preferredUnitId: 'bottle',
        initialPriceDzd: 145,
      );
      expect(product.name, 'Lait Candia 1L');
      expect(product.brand, 'Candia');

      final searchResults = await productRepo.searchProducts('candia');
      expect(searchResults, hasLength(1));
      expect(searchResults.first.id, product.id);

      final byId = await productRepo.getProductById(product.id);
      expect(byId?.id, product.id);
    });

    test('creates purchase, updates product lastPriceDzd, and aggregates monthly total', () async {
      final product = await productRepo.createProduct(
        name: 'Café Boun 250g',
        initialPriceDzd: 250,
      );

      final now = DateTime.now();
      final purchase = await purchaseRepo.createPurchase(
        productId: product.id,
        quantity: 2.0,
        unitId: 'pack',
        priceDzd: 250,
        isUnitPrice: true,
        purchasedAt: now,
        note: 'Achat du matin',
      );

      expect(purchase.totalDzd, 500);

      // Product last price should automatically update to 250
      final updatedProduct = await productRepo.getProductById(product.id);
      expect(updatedProduct?.lastPriceDzd, 250);

      final monthlyTotal = await purchaseRepo.watchMonthlyTotal(now.year, now.month).first;
      expect(monthlyTotal.dinars, 500);
    });

    test('tracks Later Buy items and status lifecycle', () async {
      final product = await productRepo.createProduct(name: 'Huile Elio 5L');

      final laterItem = await laterBuyRepo.createLaterBuyItem(
        productId: product.id,
        observedPriceDzd: 700,
        observedQuantity: 1.0,
        observedUnitId: 'bottle',
        targetPriceDzd: 650,
        reason: 'expensive',
      );

      expect(laterItem.status, 'active');

      var activeItems = await laterBuyRepo.watchItemsByStatus('active').first;
      expect(activeItems, hasLength(1));
      expect(activeItems.first.id, laterItem.id);

      // Mark as bought
      await laterBuyRepo.resolveAsBought(
        laterBuyId: laterItem.id,
        quantity: 1.0,
        unitId: 'bottle',
        finalPriceDzd: 640,
        isUnitPrice: true,
        purchasedAt: DateTime.now(),
      );

      final boughtItems = await laterBuyRepo.watchItemsByStatus('bought').first;
      expect(boughtItems, hasLength(1));
      expect(boughtItems.first.status, 'bought');

      activeItems = await laterBuyRepo.watchItemsByStatus('active').first;
      expect(activeItems, isEmpty);
    });

    test('creates, filters, and searches food notes', () async {
      final now = DateTime.now();
      final note = await notebookRepo.createNote(
        title: 'ملاحظة أسعار التمور',
        body: 'دقلة نور في سوق بومعطي 650 دج للكيلوغرام، جودة ممتازة.',
        noteType: 'price_discovery',
        eventAt: now,
      );

      expect(note.title, contains('التمور'));

      final allNotes = await notebookRepo.watchAllNotes().first;
      expect(allNotes, hasLength(1));
      expect(allNotes.first.id, note.id);
    });

    test('updates settings and exports complete local backup JSON', () async {
      await settingsRepo.updateMonthlyBudget(75000);
      await settingsRepo.updateLanguage('fr');
      await settingsRepo.updateHouseholdSize(5);

      final updatedProfile = await settingsRepo.getProfile();
      expect(updatedProfile?.monthlyBudgetDzd, 75000);
      expect(updatedProfile?.language, 'fr');
      expect(updatedProfile?.householdSize, 5);

      final jsonString = await settingsRepo.exportDataAsJson();
      expect(jsonString, contains('"version": "1.0.0"'));
      expect(jsonString, contains('"products"'));
      expect(jsonString, contains('"purchases"'));
      expect(jsonString, contains('"laterBuy"'));
      expect(jsonString, contains('"notes"'));
    });

    test('exports purchases as CSV correctly', () async {
      final product = await productRepo.createProduct(name: 'Sucre Cevital 1kg', initialPriceDzd: 100);
      await purchaseRepo.createPurchase(
        productId: product.id,
        quantity: 3,
        unitId: 'kg',
        priceDzd: 100,
        isUnitPrice: true,
        purchasedAt: DateTime(2026, 9, 16),
        note: 'Sucre pour café',
      );

      final csv = await settingsRepo.exportPurchasesAsCsv();
      expect(csv, contains('id,local_date,product_name,quantity,unit,price_dzd,total_dzd'));
      expect(csv, contains('Sucre Cevital 1kg'));
      expect(csv, contains('300'));
    });

    test('restores database from JSON backup correctly', () async {
      final sampleJson = '''
      {
        "version": "1.0.0",
        "exportedAt": "2026-09-16T12:00:00Z",
        "products": [
          {
            "id": "prod-restore-1",
            "name": "Fromage Portion Berbère",
            "brand": "Berbère",
            "lastPriceDzd": 180
          }
        ],
        "purchases": [
          {
            "id": "pur-restore-1",
            "productId": "prod-restore-1",
            "quantity": 2,
            "unitId": "pack",
            "totalDzd": 360,
            "purchasedAt": "2026-09-16T10:00:00Z",
            "localDate": "2026-09-16"
          }
        ]
      }
      ''';

      final result = await settingsRepo.importDataFromJson(sampleJson);
      expect(result, isTrue);

      final restoredProduct = await productRepo.getProductById('prod-restore-1');
      expect(restoredProduct, isNotNull);
      expect(restoredProduct!.name, 'Fromage Portion Berbère');

      final purchase = await (db.select(db.purchases)..where((t) => t.id.equals('pur-restore-1'))).getSingleOrNull();
      expect(purchase, isNotNull);
      expect(purchase!.totalDzd, 360);
    });

    test('manages shopping lists, items, and completion status', () async {
      final shoppingRepo = DriftShoppingListRepository(db);

      // Create list
      final list = await shoppingRepo.createList(title: 'قائمة نهاية الأسبوع');
      expect(list.title, 'قائمة نهاية الأسبوع');

      // Add item
      final item1 = await shoppingRepo.addItem(
        listId: list.id,
        customName: 'طماطم مصبرة مصطفى',
        quantity: 2.0,
        unitId: 'can',
        estimatedPriceDzd: 180,
      );
      expect(item1.customName, 'طماطم مصبرة مصطفى');
      expect(item1.isCompleted, isFalse);

      final items = await shoppingRepo.watchListItems(list.id).first;
      expect(items, hasLength(1));

      // Toggle completed
      await shoppingRepo.toggleItemCompleted(item1.id, true);
      final updatedItems = await shoppingRepo.watchListItems(list.id).first;
      expect(updatedItems.first.isCompleted, isTrue);

      // Delete item
      await shoppingRepo.deleteItem(item1.id);
      final emptyItems = await shoppingRepo.watchListItems(list.id).first;
      expect(emptyItems, isEmpty);

      // Default list creation
      final defaultList = await shoppingRepo.getOrCreateDefaultList();
      expect(defaultList, isNotNull);
    });
  });
}
