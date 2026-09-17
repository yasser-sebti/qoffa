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
import 'package:qoffa/features/calendar/presentation/calendar_screen.dart';
import 'package:qoffa/features/home/presentation/home_screen.dart';
import 'package:qoffa/features/later_buy/presentation/later_buy_screen.dart';
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
    overrides: [
      databaseProvider.overrideWithValue(db),
    ],
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
    testWidgets('HomeScreen renders budget summary and empty state', (tester) async {
      await tester.pumpWidget(createTestableWidget(child: const HomeScreen(), db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('ميزانية الشهر'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('AddPurchaseScreen renders form and quick staples', (tester) async {
      await tester.pumpWidget(createTestableWidget(child: const AddPurchaseScreen(), db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AddPurchaseScreen), findsOneWidget);
      expect(find.text('تسجيل شراء'), findsOneWidget);
      expect(find.text('تم الشراء'), findsOneWidget);
      expect(find.text('شراء لاحقاً'), findsOneWidget);
      expect(find.text('إضافة للقائمة'), findsOneWidget);

      expect(find.text('Eggs'), findsOneWidget);
      expect(find.text('Bread'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('LaterBuyScreen renders status tabs and header', (tester) async {
      await tester.pumpWidget(createTestableWidget(child: const LaterBuyScreen(), db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LaterBuyScreen), findsOneWidget);
      expect(find.textContaining('النشطة'), findsOneWidget);
      expect(find.text('تم شراؤها'), findsOneWidget);
      expect(find.text('تم التخطي'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('CalendarScreen renders monthly header and day grid', (tester) async {
      await tester.pumpWidget(createTestableWidget(child: const CalendarScreen(), db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.text('التقويم'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('NotebookScreen renders category chips and notes header', (tester) async {
      await tester.pumpWidget(createTestableWidget(child: const NotebookScreen(), db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(NotebookScreen), findsOneWidget);
      expect(find.text('دفتر الملاحظات'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('ShoppingListsScreen renders and handles empty lists', (tester) async {
      await tester.pumpWidget(createTestableWidget(child: const ShoppingListsScreen(), db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ShoppingListsScreen), findsOneWidget);
      expect(find.text('قوائم التسوق'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('SettingsScreen renders offline trust badge and export options', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestableWidget(child: const SettingsScreen(), db: db));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('الإعدادات'), findsOneWidget);
      expect(find.text('وضع محلي فقط (بدون إنترنت)'), findsOneWidget);
      expect(find.text('تصدير نسخة احتياطية (.qoffa JSON)'), findsOneWidget);
      expect(find.text('تصدير المشتريات (CSV)'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}
