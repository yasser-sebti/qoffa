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
import 'package:qoffa/core/widgets/qoffa_confirm_dialog.dart';
import 'package:qoffa/core/widgets/qoffa_quantity_selector.dart';
import 'package:qoffa/core/widgets/qoffa_tactile_pressable.dart';
import 'package:qoffa/core/widgets/qoffa_typing_box.dart';
import 'package:qoffa/core/widgets/top_toast_notification.dart';
import 'package:qoffa/features/settings/presentation/settings_screen.dart';
import 'package:qoffa/features/settings/presentation/widgets/erase_data_sheet.dart';

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

    // 1. Seed store
    await db.into(db.stores).insert(
          StoresCompanion.insert(
            id: 'store-1',
            name: 'سوبيرات البركة',
            area: const drift.Value('القبة'),
          ),
        );

    // 2. Seed products (1 premade and 1 custom)
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: 'premade_milk',
            name: 'حليب كانديا 1 لتر',
            normalizedName: 'حليب كانديا 1 لتر',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: 'custom_cheese_1',
            name: 'جبن بربر مفروم',
            normalizedName: 'جبن بربر مفروم',
            brand: const drift.Value('بربر'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // 3. Seed purchases
    await db.into(db.purchases).insert(
          PurchasesCompanion.insert(
            id: 'p-1',
            productId: 'premade_milk',
            storeId: const drift.Value('store-1'),
            quantity: 2.0,
            unitId: 'piece',
            priceDzd: 140,
            totalDzd: 280,
            purchasedAt: now,
            localDate: now.toIso8601String().substring(0, 10),
          ),
        );

    // 4. Seed later buy
    await db.into(db.laterBuyItems).insert(
          LaterBuyItemsCompanion.insert(
            id: 'later-1',
            productId: 'custom_cheese_1',
            observedPriceDzd: 350,
            observedQuantity: 1.0,
            observedUnitId: 'piece',
            status: const drift.Value('active'),
            createdAt: now,
            updatedAt: now,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('SettingsScreen displays Erase Data tile and opens EraseDataSheet',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      createTestableWidget(child: const SettingsScreen(), db: db),
    );
    await tester.pumpAndSettle();

    // Scroll to the Erase Data section
    final eraseTileFinder = find.text('مسح البيانات نهائياً');
    await tester.scrollUntilVisible(eraseTileFinder, 300);
    expect(eraseTileFinder, findsOneWidget);

    // Tap to open sheet
    await tester.tap(eraseTileFinder);
    await tester.pumpAndSettle();

    // Verify sheet title and reset card are visible
    expect(find.byType(EraseDataSheet), findsOneWidget);
    expect(find.text('مسح كافة البيانات (إعادة ضبط شاملة)'), findsWidgets);
    expect(find.text('المشتريات والنشاط'), findsWidgets);
    expect(find.text('الشراء لاحقاً (الكل)'), findsOneWidget);
    expect(find.text('المحلات المضافة'), findsOneWidget);
    expect(find.text('الأطعمة المخصصة'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('EraseDataSheet Purchases tab allows switching to date range and using stepper',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      createTestableWidget(child: const EraseDataSheet(), db: db),
    );
    await tester.pumpAndSettle();

    // By default, mode is 'كل الأوقات'
    expect(find.text('كل الأوقات'), findsOneWidget);
    expect(find.text('تحديد فترة معينة'), findsOneWidget);

    // Switch to date range mode
    await tester.tap(find.text('تحديد فترة معينة'));
    await tester.pumpAndSettle();

    // Presets should be visible
    expect(find.text('اليوم فقط'), findsOneWidget);
    expect(find.text('آخر 7 أيام'), findsOneWidget);
    expect(find.text('حذف السجلات الأقدم من (أيام)'), findsOneWidget);

    // Tap older than days preset
    await tester.tap(find.text('حذف السجلات الأقدم من (أيام)'));
    await tester.pumpAndSettle();

    // Verify QoffaQuantitySelector appears
    expect(find.byType(QoffaQuantitySelector), findsOneWidget);
    expect(find.text('30 يوم'), findsOneWidget);

    // Increment days
    final plusBtn = find.byIcon(Icons.add_rounded);
    await tester.tap(plusBtn);
    await tester.pumpAndSettle();
    expect(find.text('31 يوم'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('EraseDataSheet Shops tab supports live search and selection',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      createTestableWidget(child: const EraseDataSheet(), db: db),
    );
    await tester.pumpAndSettle();

    // Switch to Shops tab using ensureVisible
    final shopsTabFinder = find.text('المحلات المضافة');
    await tester.ensureVisible(shopsTabFinder);
    await tester.tap(shopsTabFinder);
    await tester.pumpAndSettle();

    // Verify search box and store item
    expect(find.byType(QoffaTypingBox), findsOneWidget);
    expect(find.text('سوبيرات البركة'), findsOneWidget);

    // Select store item
    await tester.tap(find.text('سوبيرات البركة'));
    await tester.pumpAndSettle();

    expect(find.text('تم تحديد: 1 / 1'), findsOneWidget);

    // Deselect all
    await tester.tap(find.text('إلغاء التحديد'));
    await tester.pumpAndSettle();

    expect(find.text('تم تحديد: 0 / 1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('EraseDataSheet Custom Foods tab shows custom foods only and excludes premade staples',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      createTestableWidget(child: const EraseDataSheet(), db: db),
    );
    await tester.pumpAndSettle();

    // Switch to Custom Foods tab using ensureVisible
    final foodsTabFinder = find.text('الأطعمة المخصصة');
    await tester.ensureVisible(foodsTabFinder);
    await tester.tap(foodsTabFinder);
    await tester.pumpAndSettle();

    // Custom food should be shown, premade food should not be in the list
    expect(find.text('جبن بربر مفروم'), findsOneWidget);
    expect(find.text('حليب كانديا 1 لتر'), findsNothing);

    // Select custom food
    await tester.tap(find.text('جبن بربر مفروم'));
    await tester.pumpAndSettle();

    expect(find.text('تم تحديد: 1 / 1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('Erase All Data triggers QoffaConfirmDialog and performs full wipe',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      createTestableWidget(child: const EraseDataSheet(), db: db),
    );
    await tester.pumpAndSettle();

    // Tap Erase All Data button
    final eraseAllBtn = find.widgetWithText(
      QoffaTactilePressable,
      'مسح كافة البيانات (إعادة ضبط شاملة)',
    );
    await tester.tap(eraseAllBtn);
    await tester.pumpAndSettle();

    // Verify QoffaConfirmDialog dialog appears
    expect(find.byType(QoffaConfirmDialog), findsOneWidget);
    expect(find.text('تأكيد إعادة الضبط الشاملة'), findsOneWidget);

    // Confirm deletion
    final confirmBtn = find.widgetWithText(QoffaTactilePressable, 'مسح نهائي');
    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    // Drain the QoffaToast timer
    await tester.pump(const Duration(seconds: 4));

    // Verify database was erased
    final purchases = await db.select(db.purchases).get();
    final laterBuys = await db.select(db.laterBuyItems).get();
    final stores = await db.select(db.stores).get();
    final customProds = await (db.select(db.products)
          ..where((t) =>
              t.id.like('premade_%').not() & t.id.like('sys_%').not()))
        .get();
    final premadeProds = await (db.select(db.products)
          ..where((t) => t.id.like('premade_%')))
        .get();

    expect(purchases, isEmpty);
    expect(laterBuys, isEmpty);
    expect(stores, isEmpty);
    expect(customProds, isEmpty);
    // Premade staple product is preserved
    expect(premadeProds, isNotEmpty);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
