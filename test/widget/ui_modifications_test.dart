import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/localization/app_localizations.dart';
import 'package:qoffa/app/theme/qoffa_colors.dart';
import 'package:qoffa/app/theme/qoffa_theme.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';
import 'package:qoffa/core/money/dzd_amount.dart';
import 'package:qoffa/core/widgets/qoffa_animated_counter.dart';
import 'package:qoffa/core/widgets/qoffa_layout.dart';
import 'package:qoffa/core/widgets/qoffa_pressable.dart';
import 'package:qoffa/core/widgets/qoffa_tactile_pressable.dart';
import 'package:qoffa/core/widgets/top_toast_notification.dart';
import 'package:qoffa/features/home/presentation/home_screen.dart';
import 'package:qoffa/features/later_buy/data/later_buy_repository.dart';
import 'package:qoffa/features/insights/domain/services/was_it_worth_waiting_service.dart';
import 'package:qoffa/features/later_buy/presentation/later_buy_screen.dart';
import 'package:qoffa/features/purchases/data/purchase_repository.dart';
import 'package:qoffa/features/purchases/presentation/add_purchase_screen.dart';

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
  late LaterBuyRepository laterRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final purchaseRepo = DriftPurchaseRepository(db);
    laterRepo = DriftLaterBuyRepository(db, purchaseRepo);
  });

  tearDown(() async {
    QoffaToast.hide();
    await db.close();
  });

  group('Localization single word Remaining Budget', () {
    test('remainingBudget is strictly a single word across all locales', () {
      final arL10n = AppLocalizations(const Locale('ar'));
      final frL10n = AppLocalizations(const Locale('fr'));
      final enL10n = AppLocalizations(const Locale('en'));

      expect(arL10n.remainingBudget.trim(), 'المتبقي');
      expect(frL10n.remainingBudget.trim(), 'Restant');
      expect(enL10n.remainingBudget.trim(), 'Remaining');
      expect(arL10n.remainingBudget.trim().contains(' '), isFalse);
      expect(frL10n.remainingBudget.trim().contains(' '), isFalse);
      expect(enL10n.remainingBudget.trim().contains(' '), isFalse);
    });
  });

  group('HomeScreen empty state refinements', () {
    testWidgets('Empty state hides subheader and uses remove_shopping_cart icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(child: const HomeScreen(), db: db),
      );
      await tester.pumpAndSettle();

      // Find QoffaEmptyState
      final emptyStateFinder = find.byType(QoffaEmptyState);
      expect(emptyStateFinder, findsOneWidget);

      final emptyStateWidget = tester.widget<QoffaEmptyState>(emptyStateFinder);
      expect(emptyStateWidget.icon, Icons.remove_shopping_cart_rounded);
      expect(emptyStateWidget.message, isNotNull);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });

  group('AddPurchaseScreen UI and Notifications', () {
    testWidgets('Renders budget card at top, counter, and filled New Store button', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Insert product and store
      final now = DateTime.now().toUtc();
      await db.into(db.products).insert(
            ProductsCompanion.insert(
              id: 'prod-milk',
              name: 'Candia Milk 1L',
              normalizedName: 'candia milk 1l',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        createTestableWidget(
          child: const AddPurchaseScreen(initialProductId: 'prod-milk'),
          db: db,
        ),
      );
      await tester.pumpAndSettle();

      // Animated counter exists with stable key
      final counterFinder = find.byKey(
        const ValueKey('add-screen-last-price-counter'),
      );
      expect(counterFinder, findsOneWidget);
      expect(find.byType(QoffaAnimatedCounter), findsWidgets);

      // Open Store Search Picker Sheet
      final storeRowButton = find.text('اختر المتجر');
      expect(storeRowButton, findsOneWidget);
      await tester.tap(storeRowButton);
      await tester.pumpAndSettle();

      // Verify + New store button inside the picker sheet is filled green
      final newStoreButton = find.byWidgetPredicate(
        (widget) =>
            widget is QoffaTactilePressable &&
            widget.label == 'متجر جديد' &&
            widget.style == QoffaTactileStyle.fill,
      );
      expect(newStoreButton, findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    test('showWithProgress template configures 7-second timer and progress bar', () {
      QoffaToast.showWithProgress(
        message: 'تم الشراء بنجاح',
        title: 'تم الحفظ',
        type: QoffaNotificationType.approved,
      );

      final data = QoffaToast.activeToast.value;
      expect(data, isNotNull);
      expect(data!.showProgress, isTrue);
      expect(data.duration, const Duration(seconds: 7));
      expect(data.type, QoffaNotificationType.approved);
      expect(data.message, 'تم الشراء بنجاح');
      QoffaToast.hide();
    });
  });

  group('LaterBuyScreen Edit Price & Accordion Dropdown', () {
    testWidgets('Active items have Edit Price button beside Delete', (
      tester,
    ) async {
      final now = DateTime.now().toUtc();
      await db.into(db.products).insert(
            ProductsCompanion.insert(
              id: 'prod-milk-test',
              name: 'Candia Milk 1L',
              normalizedName: 'candia milk 1l',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await laterRepo.createLaterBuyItem(
        productId: 'prod-milk-test',
        observedPriceDzd: 150,
        observedQuantity: 1.0,
        observedUnitId: 'piece',
      );

      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pumpAndSettle();

      // Verify edit button is present with edit_outlined icon
      final editButtonFinder = find.byIcon(Icons.edit_outlined);
      expect(editButtonFinder, findsOneWidget);

      // Verify delete button is also present
      final deleteButtonFinder = find.byIcon(Icons.delete_outline_rounded);
      expect(deleteButtonFinder, findsOneWidget);

      // Tap Edit button
      await tester.tap(editButtonFinder);
      await tester.pumpAndSettle();

      // Bottom sheet for editing price is displayed
      expect(find.text('تعديل السعر المرصود'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter new price 160
      await tester.enterText(find.byType(TextField), '160');
      await tester.pumpAndSettle();

      // Tap Save in bottom sheet
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      // Price is updated in UI
      expect(find.text('160 DA'), findsOneWidget);

      QoffaToast.hide();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('Bought items have accordion dropdown chevron toggle', (
      tester,
    ) async {
      final now = DateTime.now().toUtc();
      await db.into(db.products).insert(
            ProductsCompanion.insert(
              id: 'prod-cheese',
              name: 'Fromage Portion',
              normalizedName: 'fromage portion',
              createdAt: now,
              updatedAt: now,
            ),
          );
      final item = await laterRepo.createLaterBuyItem(
        productId: 'prod-cheese',
        observedPriceDzd: 200,
        observedQuantity: 1.0,
        observedUnitId: 'piece',
      );
      await laterRepo.resolveAsBought(
        laterBuyId: item.id,
        quantity: 1.0,
        unitId: 'piece',
        finalPriceDzd: 180,
        isUnitPrice: false,
        purchasedAt: now,
      );

      await tester.pumpWidget(
        createTestableWidget(child: const LaterBuyScreen(), db: db),
      );
      await tester.pumpAndSettle();

      // Switch to Bought tab
      await tester.tap(find.text('تم شراؤها'));
      QoffaToast.hide();
      await tester.pumpAndSettle();

      expect(find.text('Fromage Portion'), findsOneWidget);

      // Verify dropdown chevron button exists
      final chevronFinder = find.byIcon(Icons.keyboard_arrow_down_rounded);
      expect(chevronFinder, findsOneWidget);

      // Prices are collapsed initially (not visible)
      expect(find.text('السعر المرصود'), findsNothing);

      // Tap chevron to expand
      await tester.tap(chevronFinder);
      await tester.pumpAndSettle();

      // Prices are now expanded and visible
      expect(find.text('السعر المرصود'), findsOneWidget);

      // Tap chevron again to collapse
      await tester.tap(chevronFinder);
      await tester.pumpAndSettle();

      expect(find.text('السعر المرصود'), findsNothing);
      expect(chevronFinder, findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    test('WasItWorthWaitingService highlights positive and negative differences correctly', () {
      final now = DateTime.now();
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final savedResult = WasItWorthWaitingService.calculate(
        observedPrice: const DzdAmount(150),
        observedQuantity: Decimal.one,
        observedUnitId: 'piece',
        observedDate: threeDaysAgo,
        finalPrice: const DzdAmount(120),
        finalQuantity: Decimal.one,
        finalUnitId: 'piece',
        purchaseDate: now,
      );
      expect(savedResult.outcomeType, LaterBuyOutcomeType.savedMoney);
      expect(savedResult.absoluteDifferenceDzd.dinars, 30);
      expect(savedResult.daysWaited, 3);

      final paidMoreResult = WasItWorthWaitingService.calculate(
        observedPrice: const DzdAmount(150),
        observedQuantity: Decimal.one,
        observedUnitId: 'piece',
        observedDate: threeDaysAgo,
        finalPrice: const DzdAmount(180),
        finalQuantity: Decimal.one,
        finalUnitId: 'piece',
        purchaseDate: now,
      );
      expect(paidMoreResult.outcomeType, LaterBuyOutcomeType.paidMore);
      expect(paidMoreResult.absoluteDifferenceDzd.dinars, -30);
    });
  });

  group('HomeScreen Stat Cards Symmetry and Watchlist Styling', () {
    testWidgets('Both stat cards have identical dimensions and correct watchlist colors', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          child: const HomeScreen(),
          db: db,
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      final pressables = find.byType(QoffaPressable);
      expect(pressables, findsAtLeastNWidgets(2));

      final card1Size = tester.getSize(pressables.at(0));
      final card2Size = tester.getSize(pressables.at(1));

      // Both cards MUST have the exact same height and width
      expect(card1Size.height, equals(card2Size.height));
      expect(card1Size.width, equals(card2Size.width));

      // Watchlist count header must NOT be green; must use primary navy normal text color
      final countText = tester.widget<Text>(find.text('0'));
      expect(countText.style?.color, equals(QoffaColors.primaryNavy));

      // Watchlist icon must be coral, not green
      final scheduleIcon = tester.widget<Icon>(find.byIcon(Icons.schedule_rounded));
      expect(scheduleIcon.color, equals(const Color(0xFFE0533C)));

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}
