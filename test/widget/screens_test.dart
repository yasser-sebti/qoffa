import 'package:drift/drift.dart' hide Column;
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
import 'package:qoffa/core/widgets/qoffa_quantity_selector.dart';
import 'package:qoffa/features/calendar/presentation/calendar_screen.dart';
import 'package:qoffa/features/home/presentation/home_screen.dart';
import 'package:qoffa/features/later_buy/presentation/later_buy_screen.dart';
import 'package:qoffa/features/notebook/data/notebook_repository.dart';
import 'package:qoffa/features/notebook/presentation/notebook_screen.dart';
import 'package:qoffa/features/purchases/presentation/add_purchase_screen.dart';
import 'package:qoffa/features/settings/presentation/settings_screen.dart';
import 'package:qoffa/features/shopping_lists/presentation/shopping_lists_screen.dart';

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

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Qoffa UI Screens Widget Integration', () {
    testWidgets('HomeScreen renders budget summary and empty state', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: const HomeScreen(), db: db),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('ميزانية الشهر'), findsOneWidget);
      expect(find.text('قفتك ما زالت فارغة'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('AddPurchaseScreen renders item row, opens bottom sheet, and can select & clear item', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: const AddPurchaseScreen(), db: db),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AddPurchaseScreen), findsOneWidget);
      expect(find.text('إضافة شراء'), findsOneWidget);
      // Row button to add an item
      expect(find.text('إضافة مادة غذائية'), findsOneWidget);

      // Tap to open bottom sheet
      await tester.tap(find.text('إضافة مادة غذائية'));
      await tester.pumpAndSettle();

      // Verify bottom sheet appears with food name bar and recent foods
      expect(find.text('اسم المادة الغذائية'), findsOneWidget);
      expect(find.text('العناصر المختارة مؤخراً'), findsOneWidget);
      expect(find.text('Candia Milk 1L'), findsOneWidget);

      // Tap Candia Milk 1L from recent picked foods
      await tester.tap(find.text('Candia Milk 1L').first);
      await tester.pumpAndSettle();

      // Selected item row now appears with Candia Milk 1L and remove button
      expect(find.text('Candia Milk 1L'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      // Tap remove button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Returns to Add item row button
      expect(find.text('إضافة مادة غذائية'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets(
      'AddPurchaseScreen price calculator updates dynamically on price change',
      (tester) async {
        await db.into(db.products).insert(
              ProductsCompanion.insert(
                id: 'prod_candia',
                name: 'Candia Milk 1L',
                normalizedName: 'candia milk 1l',
                preferredUnitId: const Value('piece'),
                lastPriceDzd: const Value(145),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );

        await tester.pumpWidget(
          createTestableWidget(
            child: const AddPurchaseScreen(initialProductId: 'prod_candia'),
            db: db,
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Last price'), findsOneWidget);
        expect(find.text('145 DA'), findsWidgets);
        expect(find.text('Today'), findsOneWidget);
        expect(find.text('0 DA'), findsOneWidget);

        // Tap Today to edit price
        await tester.tap(find.text('Today'));
        await tester.pumpAndSettle();

        final priceField = find.byType(TextField).last;
        await tester.enterText(priceField, '165');
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(find.text('+20 DA'), findsOneWidget);
        expect(find.byIcon(Icons.trending_up_rounded), findsOneWidget);

        // Tap Today again to enter 125
        await tester.tap(find.text('Today'));
        await tester.pumpAndSettle();

        final priceField2 = find.byType(TextField).last;
        await tester.enterText(priceField2, '125');
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        expect(find.text('-20 DA'), findsOneWidget);
        expect(find.byIcon(Icons.trending_down_rounded), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );

    testWidgets(
      'AddPurchaseScreen quantity controls and custom unit dropdown work correctly',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            child: const AddPurchaseScreen(),
            db: db,
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Quantity and Unit controls are rendered
        expect(find.text('Quantity'), findsOneWidget);
        expect(find.text('Unit'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);

        // Tap plus to increment quantity to 2
        await tester.tap(
          find.descendant(
            of: find.byType(QoffaQuantitySelector),
            matching: find.byIcon(Icons.add_rounded),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('2'), findsOneWidget);

        // Tap minus to decrement to 1
        await tester.tap(find.byIcon(Icons.remove_rounded));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);

        // Tap minus again to decrement to 0 (minimum threshold)
        await tester.tap(find.byIcon(Icons.remove_rounded));
        await tester.pumpAndSettle();
        expect(find.text('0'), findsOneWidget);

        // Tap minus again; stays at 0
        await tester.tap(find.byIcon(Icons.remove_rounded));
        await tester.pumpAndSettle();
        expect(find.text('0'), findsOneWidget);

        // Open custom Unit dropdown
        expect(find.text('Piece'), findsOneWidget);
        await tester.tap(find.text('Piece'));
        await tester.pumpAndSettle();

        // Check that custom unit sheet options appear
        expect(find.text('Kilogram'), findsOneWidget);

        // Select Kilogram
        await tester.tap(find.text('Kilogram'));
        await tester.pumpAndSettle();

        // Selected unit is now Kilogram
        expect(find.text('Kilogram'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );

    testWidgets('LaterBuyScreen renders status tabs and header', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(LaterBuyScreen), findsOneWidget);
      expect(find.textContaining('نشطة'), findsOneWidget);
      expect(find.text('تم شراؤها'), findsOneWidget);
      expect(find.text('متخطاة'), findsOneWidget);
      expect(find.text('لا شيء مؤجل الآن'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('CalendarScreen renders monthly header and day grid', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: const CalendarScreen(), db: db),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.text('التقويم'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('NotebookScreen renders category chips and notes header', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: const NotebookScreen(), db: db),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(NotebookScreen), findsOneWidget);
      expect(find.text('دفتر الأغذية'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.text('دفترك جاهز'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('NotebookScreen can open edit sheet for an existing note', (
      tester,
    ) async {
      final repo = DriftNotebookRepository(db);
      await repo.createNote(
        title: 'وصفة شربة فريك',
        body: 'المقادير: فريك، لحم، حمص، كزبرة، نعناع، طماطم مصبرة.',
        noteType: 'meal_idea',
        eventAt: DateTime.now(),
      );

      await tester.pumpWidget(
        createTestableWidget(child: const NotebookScreen(), db: db),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('وصفة شربة فريك'), findsOneWidget);

      await tester.tap(find.text('وصفة شربة فريك'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('تعديل الملاحظة'), findsOneWidget);
      expect(find.text('حفظ'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('ShoppingListsScreen renders and handles empty lists', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: const ShoppingListsScreen(), db: db),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ShoppingListsScreen), findsOneWidget);
      expect(find.text('قائمة الأغذية والأسعار'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets(
      'SettingsScreen renders offline trust badge and export options',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestableWidget(child: const SettingsScreen(), db: db),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(SettingsScreen), findsOneWidget);
        expect(find.text('الإعدادات'), findsOneWidget);
        expect(find.text('بيانات محلية وآمنة'), findsOneWidget);
        expect(find.text('نسخ النسخة الاحتياطية'), findsOneWidget);
        expect(find.text('نسخ المشتريات CSV'), findsOneWidget);

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );
  });
}
