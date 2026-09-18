import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/localization/app_localizations.dart';
import 'package:qoffa/app/theme/qoffa_theme.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';
import 'package:qoffa/core/widgets/top_toast_notification.dart';
import 'package:qoffa/features/shopping_lists/presentation/shopping_lists_screen.dart';
import 'package:qoffa/features/shopping_lists/presentation/widgets/add_food_item_sheet.dart';
import 'package:qoffa/features/shopping_lists/presentation/widgets/edit_food_item_sheet.dart';
import 'package:qoffa/features/shopping_lists/presentation/widgets/food_grid_card.dart';
import 'package:qoffa/features/shopping_lists/presentation/widgets/market_filter_sheet.dart';

Widget createTestableWidget({
  required Widget child,
  required AppDatabase db,
  Locale locale = const Locale('ar'),
}) {
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: QoffaTheme.lightTheme,
      home: TopToastLayer(child: Scaffold(body: child)),
    ),
  );
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());

    final now = DateTime.now().toUtc();

    // 1. Seed stores
    await db.into(db.stores).insert(
          StoresCompanion.insert(
            id: 'store-1',
            name: 'سوبيرات البركة',
          ),
        );

    // 2. Seed products (1 premade and 1 custom)
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: 'premade_milk',
            name: 'حليب كانديا 1 لتر',
            normalizedName: 'حليب كانديا 1 لتر',
            brand: const drift.Value('Candia'),
            categoryId: const drift.Value('cat_dairy'),
            lastPriceDzd: const drift.Value(140),
            createdAt: now,
            updatedAt: now,
          ),
        );

    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: 'custom_tomatoes',
            name: 'طماطم طازجة',
            normalizedName: 'طماطم طازجة',
            categoryId: const drift.Value('cat_produce'),
            lastPriceDzd: const drift.Value(120),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // 3. Seed purchases
    await db.into(db.purchases).insert(
          PurchasesCompanion.insert(
            id: 'purch-1',
            productId: 'premade_milk',
            storeId: const drift.Value('store-1'),
            quantity: 1,
            unitId: 'piece',
            priceDzd: 140,
            totalDzd: 140,
            purchasedAt: now,
            localDate: '2026-09-18',
          ),
        );

    await db.into(db.purchases).insert(
          PurchasesCompanion.insert(
            id: 'purch-2',
            productId: 'custom_tomatoes',
            storeId: const drift.Value('store-1'),
            quantity: 1,
            unitId: 'kg',
            priceDzd: 120,
            totalDzd: 120,
            purchasedAt: now,
            localDate: '2026-09-18',
          ),
        );
  });

  tearDown(() async {
    QoffaToast.hide();
    await db.close();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        child: const ShoppingListsScreen(),
        db: db,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> disposeScreen(WidgetTester tester) async {
    QoffaToast.hide();
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('Food Catalog & Price Directory Screen Tests', () {
    testWidgets('Renders Food Catalog header with Update, Filter, and Add buttons',
        (tester) async {
      await pumpScreen(tester);

      // Verify Screen Title
      expect(find.text('قائمة الأغذية والأسعار'), findsOneWidget);

      // Verify Top Action Buttons
      expect(find.byIcon(Icons.cloud_sync_rounded), findsOneWidget);
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_rounded), findsOneWidget);

      // Verify Search bar is present
      expect(find.byType(TextField), findsOneWidget);

      await disposeScreen(tester);
    });

    testWidgets('Renders 2x2 grid food cards separated by categories',
        (tester) async {
      await pumpScreen(tester);

      // Verify 2x2 Grid cards are rendered
      expect(find.byType(FoodGridCard), findsNWidgets(2));

      // Verify product names and prices in the cards
      expect(find.text('حليب كانديا 1 لتر'), findsOneWidget);
      expect(find.text('140'), findsOneWidget);
      expect(find.text('طماطم طازجة'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);

      // Verify Category Headers (appear in both chips and section headers)
      expect(find.text('خضر وفواكه'), findsWidgets);
      expect(find.text('حليب ومشتقاته وبيض'), findsWidgets);

      await disposeScreen(tester);
    });

    testWidgets('Tapping Filter button opens MarketFilterSheet', (tester) async {
      await pumpScreen(tester);

      // Tap filter icon
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify filter sheet title & options
      expect(find.byType(MarketFilterSheet), findsOneWidget);
      expect(find.text('تصفية وترتيب'), findsWidgets);
      expect(find.text('التاريخ: الأحدث أولاً'), findsOneWidget);
      expect(find.text('السعر: من الأقل للأعلى'), findsOneWidget);

      await disposeScreen(tester);
    });

    testWidgets('Tapping Add button opens AddFoodItemSheet', (tester) async {
      await pumpScreen(tester);

      // Tap add icon
      await tester.tap(find.byIcon(Icons.add_circle_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify add food item sheet
      expect(find.byType(AddFoodItemSheet), findsOneWidget);
      expect(find.text('إضافة منتج غذائي'), findsWidgets);

      await disposeScreen(tester);
    });

    testWidgets('Tapping premade item opens EditFoodItemSheet with locked name',
        (tester) async {
      await pumpScreen(tester);

      // Tap on the premade milk card
      await tester.tap(find.text('حليب كانديا 1 لتر'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify EditFoodItemSheet is shown
      expect(find.byType(EditFoodItemSheet), findsOneWidget);
      expect(find.text('تعديل المنتج'), findsOneWidget);

      // Verify Premade item indicator banner and locked name field label
      expect(find.text('اسم المنتج ثابت (قائمة جاهزة)'), findsOneWidget);
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);

      // Price and Delete buttons are accessible
      expect(find.text('140'), findsWidgets);
      expect(find.text('حذف'), findsOneWidget);
      expect(find.text('حفظ'), findsOneWidget);

      await disposeScreen(tester);
    });

    testWidgets('Tapping custom item opens EditFoodItemSheet with editable name',
        (tester) async {
      await pumpScreen(tester);

      // Tap on the custom tomatoes card
      await tester.tap(find.text('طماطم طازجة'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify EditFoodItemSheet is shown
      expect(find.byType(EditFoodItemSheet), findsOneWidget);

      // Custom item does NOT have locked name banner
      expect(find.text('اسم السلعة / المنتج'), findsOneWidget);
      expect(find.text('اسم المنتج ثابت (قائمة جاهزة)'), findsNothing);

      await disposeScreen(tester);
    });

    testWidgets('Renders properly in English when English locale is selected',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: const ShoppingListsScreen(),
          db: db,
          locale: const Locale('en'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // English Header
      expect(find.text('Food & Price List'), findsOneWidget);

      // English Search placeholder
      expect(find.text('Search food item, brand, or barcode...'), findsOneWidget);

      // English chips: "All"
      expect(find.text('All'), findsOneWidget);

      // English Category Names: "Fresh Produce" and "Dairy & Eggs"
      expect(find.text('Fresh Produce'), findsWidgets);
      expect(find.text('Dairy & Eggs'), findsWidgets);

      // English currency: "DA"
      expect(find.text('DA'), findsWidgets);

      // English Date formatting (Sep 18)
      expect(find.text('Sep 18'), findsWidgets);

      // Tap Filter button in English
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(MarketFilterSheet), findsOneWidget);
      expect(find.text('Filter & Sort'), findsWidgets);
      expect(find.text('Price: Low to High'), findsOneWidget);

      await disposeScreen(tester);
    });
  });
}
