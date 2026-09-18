import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/localization/app_localizations.dart';
import 'package:qoffa/app/theme/qoffa_theme.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';
import 'package:qoffa/core/widgets/qoffa_tactile_pressable.dart';
import 'package:qoffa/core/widgets/top_toast_notification.dart';
import 'package:qoffa/features/later_buy/data/later_buy_repository.dart';
import 'package:qoffa/features/later_buy/presentation/later_buy_screen.dart';
import 'package:qoffa/features/later_buy/presentation/qoffa_resolve_later_buy_sheet.dart';
import 'package:qoffa/features/purchases/data/purchase_repository.dart';

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
  late DriftLaterBuyRepository laterRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final purchaseRepo = DriftPurchaseRepository(db);
    laterRepo = DriftLaterBuyRepository(db, purchaseRepo);

    // Seed a product
    final now = DateTime.now().toUtc();
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: 'prod-milk-1',
            name: 'Candia Milk 1L',
            normalizedName: 'candia milk 1l',
            createdAt: now,
            updatedAt: now,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('Later Buy Screen Redesign Tests', () {
    testWidgets(
        'Renders active card with date badge, Skip, Bought, and Delete tactile buttons',
        (tester) async {
      await laterRepo.createLaterBuyItem(
        productId: 'prod-milk-1',
        observedPriceDzd: 150,
        observedQuantity: 1.0,
        observedUnitId: 'l',
        targetPriceDzd: 130,
      );

      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pumpAndSettle();

      // Verify product card and price metrics
      expect(find.text('Candia Milk 1L'), findsOneWidget);
      expect(find.text('150 DA'), findsOneWidget);
      expect(find.text('130 DA'), findsOneWidget);

      // Verify tactile buttons for both Skip (تخطي) and Bought (تم الشراء)
      expect(find.text('تخطي'), findsOneWidget);
      expect(find.text('تم الشراء'), findsOneWidget);
      expect(find.byType(QoffaTactilePressable), findsWidgets);

      // Verify header has date badge and no '+' button
      expect(find.byIcon(Icons.event_rounded), findsWidgets);
      expect(find.byIcon(Icons.add_rounded), findsNothing);

      // Verify active card has creation date and delete button
      expect(find.textContaining('أضيف في'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Tapping delete removes active item after confirmation',
        (tester) async {
      await laterRepo.createLaterBuyItem(
        productId: 'prod-milk-1',
        observedPriceDzd: 150,
        observedQuantity: 1.0,
        observedUnitId: 'l',
      );

      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pumpAndSettle();

      expect(find.text('Candia Milk 1L'), findsOneWidget);

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      // Confirmation dialog appears
      expect(find.text('حذف العنصر'), findsWidgets);
      final dialogFinder = find.byType(AlertDialog);
      expect(dialogFinder, findsOneWidget);
      // Verify no icon is displayed inside the delete confirmation dialog
      expect(
        find.descendant(of: dialogFinder, matching: find.byType(Icon)),
        findsNothing,
      );
      // Verify dialog title is centered
      final titleFinder = find.descendant(
        of: dialogFinder,
        matching: find.text('حذف العنصر'),
      );
      final titleWidget = tester.widget<Text>(titleFinder.first);
      expect(titleWidget.textAlign, TextAlign.center);

      // Confirm delete
      await tester.tap(find.text('حذف العنصر').last);
      await tester.pumpAndSettle();

      // Item should now be deleted
      expect(find.text('Candia Milk 1L'), findsNothing);
      expect(find.text('لا شيء مؤجل الآن'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Tapping Skip moves item to Skipped tab with Reactivate button and skipped date',
        (tester) async {
      await laterRepo.createLaterBuyItem(
        productId: 'prod-milk-1',
        observedPriceDzd: 150,
        observedQuantity: 1.0,
        observedUnitId: 'l',
      );

      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pumpAndSettle();

      // Tap Skip button
      await tester.tap(find.text('تخطي'));
      await tester.pumpAndSettle();

      // Active tab should now be empty
      expect(find.text('لا شيء مؤجل الآن'), findsOneWidget);

      // Switch to Skipped tab (متخطاة)
      await tester.tap(find.text('متخطاة'));
      await tester.pumpAndSettle();

      // Verify item appears in skipped tab with Reactivate action and skipped date
      expect(find.text('Candia Milk 1L'), findsOneWidget);
      expect(find.text('إعادة تنشيط'), findsOneWidget);
      expect(find.textContaining('تم التخطي في'), findsOneWidget);

      // Tap Reactivate button
      await tester.tap(find.text('إعادة تنشيط'));
      await tester.pumpAndSettle();

      // Skipped tab is now empty
      expect(find.text('لا توجد عناصر في هذا القسم'), findsWidgets);

      // Switch back to Active tab and verify it is restored
      await tester.tap(find.textContaining('نشطة'));
      await tester.pumpAndSettle();
      expect(find.text('Candia Milk 1L'), findsOneWidget);
      expect(find.text('تخطي'), findsOneWidget);
      expect(find.text('تم الشراء'), findsOneWidget);

      // Advance clock past toast timers
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets(
        'Tapping Bought opens QoffaResolveLaterBuySheet with Cancel and Confirm buttons, animated hint, and displays bought date',
        (tester) async {
      await laterRepo.createLaterBuyItem(
        productId: 'prod-milk-1',
        observedPriceDzd: 150,
        observedQuantity: 1.0,
        observedUnitId: 'l',
      );

      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pumpAndSettle();

      // Tap Bought button
      await tester.tap(find.text('تم الشراء'));
      await tester.pumpAndSettle();

      // Verify QoffaResolveLaterBuySheet is opened
      expect(find.byType(QoffaResolveLaterBuySheet), findsOneWidget);
      expect(find.text('إلغاء'), findsOneWidget); // Cancel button
      expect(find.text('تأكيد شراء العنصر'), findsOneWidget); // Sheet title
      expect(find.text('تأكيد'), findsOneWidget); // Confirm button

      // Enter purchase price (120 DA)
      final priceField = find.byType(TextField);
      expect(priceField, findsOneWidget);
      await tester.enterText(priceField, '120');
      await tester.pumpAndSettle();

      // Verify dynamic animated savings preview is shown
      expect(find.textContaining('ستوفّر '), findsOneWidget);
      expect(find.text('30 دج'), findsOneWidget);

      // Tap Confirm button
      await tester.tap(find.text('تأكيد'));
      await tester.pumpAndSettle();

      // Outcome dialog should appear ("هل كان الانتظار يستحق؟")
      expect(find.text('هل كان الانتظار يستحق؟'), findsOneWidget);
      expect(find.text('تأكيد'), findsOneWidget);

      // Close outcome dialog
      await tester.tap(find.text('تأكيد'));
      await tester.pumpAndSettle();

      // Active tab is now empty
      expect(find.text('لا شيء مؤجل الآن'), findsOneWidget);

      // Switch to Bought tab
      await tester.tap(find.text('تم شراؤها'));
      // Dismiss active toast before asserting list item
      QoffaToast.dismiss();
      await tester.pumpAndSettle();

      // Verify item appears with Bought status badge and bought date
      expect(find.text('Candia Milk 1L'), findsOneWidget);
      expect(find.textContaining('تم الشراء في'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Long list displays Scrollbar and can scroll down smoothly',
        (tester) async {
      // Seed 10 products
      final now = DateTime.now().toUtc();
      for (var i = 1; i <= 10; i++) {
        await db.into(db.products).insert(
              ProductsCompanion.insert(
                id: 'prod-$i',
                name: 'Product Item $i',
                normalizedName: 'product item $i',
                createdAt: now,
                updatedAt: now,
              ),
            );
        await laterRepo.createLaterBuyItem(
          productId: 'prod-$i',
          observedPriceDzd: 100 + i * 10,
          observedQuantity: 1.0,
          observedUnitId: 'u',
        );
      }

      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pumpAndSettle();

      // Scrollbar widget should be present
      expect(find.byType(Scrollbar), findsOneWidget);

      // Products are visible
      expect(find.textContaining('Product Item'), findsWidgets);

      // Scroll down until 10th item is visible
      await tester.scrollUntilVisible(
        find.text('Product Item 10'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();

      // 10th item is now scrolled into view
      expect(find.text('Product Item 10'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}
