import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/localization/app_localizations.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';
import 'package:qoffa/core/widgets/qoffa_tactile_pressable.dart';
import 'package:qoffa/features/purchases/presentation/add_purchase_screen.dart';
import 'package:qoffa/features/stores/data/store_repository.dart';
import 'package:qoffa/features/stores/domain/store_type.dart';
import 'package:qoffa/features/stores/presentation/qoffa_new_store_sheet.dart';

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
    // Seed initial product
    await db.into(db.products).insert(
      ProductsCompanion.insert(
        id: 'prod_test',
        name: 'Candia Milk 1L',
        normalizedName: 'candia milk 1l',
        preferredUnitId: const Value('liter'),
        lastPriceDzd: const Value(130),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('Price Per Unit & Store Controls Integration', () {
    testWidgets('Renders Price per unit and Store controls row', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: const AddPurchaseScreen(initialProductId: 'prod_test'),
          db: db,
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      // Check labels
      expect(find.text('Price per unit'), findsOneWidget);
      expect(find.text('Store'), findsOneWidget);

      // Check initial price from product
      expect(find.text('130'), findsOneWidget);
      expect(find.text('DA'), findsWidgets);

      // Check store placeholder
      expect(find.text('Select store'), findsOneWidget);

      // Check action buttons
      expect(find.text('Buy later'), findsOneWidget);
      expect(find.text('Bought'), findsOneWidget);
      expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_rounded), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 20));
    });

    testWidgets(
      'Typing in Price per unit box dynamically updates Today price calculation',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            child: const AddPurchaseScreen(initialProductId: 'prod_test'),
            db: db,
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        // Initially lastPrice = 130, price = 130, diff = 0
        expect(find.text('130 DA'), findsWidgets);

        // Find the unit price text field and enter 150
        final unitPriceField = find.widgetWithText(TextField, '130');
        await tester.enterText(unitPriceField, '150');
        await tester.pumpAndSettle();

        // Today difference should update to +20 DA
        expect(find.text('+20 DA'), findsOneWidget);
        expect(find.byIcon(Icons.trending_up_rounded), findsOneWidget);

        // Test auto comma thousands separator (15000 -> 15,000 in English)
        final unitPriceField150 = find.widgetWithText(TextField, '150');
        await tester.enterText(unitPriceField150, '15000');
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is TextField &&
                (w.controller?.text == '15,000' ||
                    w.controller?.text == '15،000'),
          ),
          findsOneWidget,
        );

        // Test clearing field displays placeholder
        final unitPriceField15000 = find.byType(TextField).first;
        await tester.enterText(unitPriceField15000, '');
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is TextField &&
                (w.decoration?.hintText?.contains('000') ?? false),
          ),
          findsOneWidget,
        );
        expect(find.text('DA'), findsWidgets);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 20));
      },
    );

    testWidgets(
      'Tapping Store button opens QoffaSearchPickerSheet and can create a new store with type, location, and rating',
      (tester) async {
        tester.view.physicalSize = const Size(412, 915);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          createTestableWidget(
            child: const AddPurchaseScreen(initialProductId: 'prod_test'),
            db: db,
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        // Tap Store selector button
        await tester.tap(find.text('Select store'));
        await tester.pumpAndSettle();

        // Verify picker sheet opened
        expect(find.text('Select store'), findsWidgets); // Title and button
        expect(find.text('Search or add store...'), findsOneWidget);
        expect(find.text('New store'), findsOneWidget);

        // Tap "+ New store" quick action button
        await tester.tap(find.text('New store'));
        await tester.pumpAndSettle();

        // Verify New Store sheet opened
        expect(find.text('New store details'), findsOneWidget);
        expect(find.text('Store name'), findsOneWidget);
        expect(find.text('Store type'), findsOneWidget);
        expect(find.text('Store location (Neighborhood / City)'), findsOneWidget);
        expect(find.text('Store rating'), findsOneWidget);

        // Enter store details inside QoffaNewStoreSheet
        final sheetTextFields = find.descendant(
          of: find.byType(QoffaNewStoreSheet),
          matching: find.byType(TextField),
        );
        expect(sheetTextFields, findsNWidgets(2));

        // 1. Name
        await tester.enterText(sheetTextFields.first, 'Supérette El Baraka');

        // 2. Select Store Type: Supermarket
        final supermarketType = find.text(StoreType.supermarket.nameEn);
        expect(supermarketType, findsOneWidget);
        await tester.tap(supermarketType);
        await tester.pumpAndSettle();

        // 3. Location
        await tester.enterText(sheetTextFields.at(1), 'Bab El Oued, Alger');

        // 4. Tap 5th star for rating
        final starIcons = find.byIcon(Icons.star_rounded);
        expect(starIcons, findsWidgets);

        // Tap Save
        final saveBtn = find.widgetWithText(QoffaTactilePressable, 'Save');
        await tester.ensureVisible(saveBtn);
        await tester.pumpAndSettle();
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        // Verify store is selected on screen!
        expect(find.text('Supérette El Baraka'), findsOneWidget);

        // Verify store is persisted in the database
        final storeRepo = DriftStoreRepository(db);
        final stores = await storeRepo.searchStores('Baraka');
        expect(stores.length, 1);
        expect(stores.first.name, 'Supérette El Baraka');
        expect(stores.first.area, 'Bab El Oued, Alger');
        expect(stores.first.storeType, 'supermarket');
        expect(stores.first.rating, 5);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 20));
      },
    );
  });
}
