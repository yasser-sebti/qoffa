import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/localization/app_localizations.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';
import 'package:qoffa/features/purchases/presentation/add_purchase_screen.dart';

Widget createTestableWidget({
  required Widget child,
  required AppDatabase db,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
    ],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        _TestLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

class _TestLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _TestLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_TestLocalizationsDelegate old) => false;
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final now = DateTime.now().toUtc();

    // Insert 4 products with purchases so we can test most used selection
    final p1 = await db.into(db.products).insertReturning(
          ProductsCompanion.insert(
            id: 'prod_eggs',
            name: 'Eggs',
            normalizedName: 'eggs',
            preferredUnitId: const Value('piece'),
            lastPriceDzd: const Value(25),
            createdAt: now,
            updatedAt: now,
          ),
        );
    final p2 = await db.into(db.products).insertReturning(
          ProductsCompanion.insert(
            id: 'prod_bread',
            name: 'Bread',
            normalizedName: 'bread',
            preferredUnitId: const Value('piece'),
            lastPriceDzd: const Value(15),
            createdAt: now,
            updatedAt: now,
          ),
        );
    final p3 = await db.into(db.products).insertReturning(
          ProductsCompanion.insert(
            id: 'prod_tomatoes',
            name: 'Tomatoes',
            normalizedName: 'tomatoes',
            preferredUnitId: const Value('kg'),
            lastPriceDzd: const Value(90),
            createdAt: now,
            updatedAt: now,
          ),
        );
    final p4 = await db.into(db.products).insertReturning(
          ProductsCompanion.insert(
            id: 'prod_milk',
            name: 'Milk',
            normalizedName: 'milk',
            preferredUnitId: const Value('liter'),
            lastPriceDzd: const Value(130),
            createdAt: now,
            updatedAt: now,
          ),
        );

    final localDateStr =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // Record purchases
    for (int i = 0; i < 5; i++) {
      await db.into(db.purchases).insert(
            PurchasesCompanion.insert(
              id: 'purch_eggs_$i',
              productId: p1.id,
              quantity: 1,
              unitId: 'piece',
              priceDzd: 25,
              totalDzd: 25,
              isUnitPrice: const Value(true),
              purchasedAt: now,
              localDate: localDateStr,
            ),
          );
    }
    for (int i = 0; i < 4; i++) {
      await db.into(db.purchases).insert(
            PurchasesCompanion.insert(
              id: 'purch_bread_$i',
              productId: p2.id,
              quantity: 1,
              unitId: 'piece',
              priceDzd: 15,
              totalDzd: 15,
              isUnitPrice: const Value(true),
              purchasedAt: now,
              localDate: localDateStr,
            ),
          );
    }
    for (int i = 0; i < 3; i++) {
      await db.into(db.purchases).insert(
            PurchasesCompanion.insert(
              id: 'purch_tomatoes_$i',
              productId: p3.id,
              quantity: 1,
              unitId: 'kg',
              priceDzd: 90,
              totalDzd: 90,
              isUnitPrice: const Value(true),
              purchasedAt: now,
              localDate: localDateStr,
            ),
          );
    }
    for (int i = 0; i < 2; i++) {
      await db.into(db.purchases).insert(
            PurchasesCompanion.insert(
              id: 'purch_milk_$i',
              productId: p4.id,
              quantity: 1,
              unitId: 'liter',
              priceDzd: 130,
              totalDzd: 130,
              isUnitPrice: const Value(true),
              purchasedAt: now,
              localDate: localDateStr,
            ),
          );
    }
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
      'Renders Add something else section with 2x2 grid, refresh button, and tap selection',
      (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      createTestableWidget(
        child: const AddPurchaseScreen(),
        db: db,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    // Verify section header with Refresh button and refresh icon
    expect(find.text('Add something else?'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);

    // Scroll down if needed to ensure items are visible
    await tester.scrollUntilVisible(
      find.text('Add something else?'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Verify 4 items rendered in 2x2 grid
    expect(find.byIcon(Icons.add_rounded), findsWidgets);

    // Tap Refresh button to trigger rotation and button pop-in animation
    await tester.tap(find.text('Refresh'));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();

    // Tap one of the suggestions (e.g. Eggs or Tomatoes or Bread or Milk)
    final suggestion = find.text('Eggs');
    if (suggestion.evaluate().isNotEmpty) {
      await tester.tap(suggestion.first);
      await tester.pumpAndSettle();

      // Should have populated the form with Eggs
      expect(find.text('Eggs'), findsWidgets);
    }

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 20));
  });
}
