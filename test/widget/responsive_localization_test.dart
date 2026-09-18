import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/localization/app_localizations.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/features/calendar/presentation/calendar_screen.dart';
import 'package:qoffa/features/home/presentation/home_screen.dart';
import 'package:qoffa/features/purchases/presentation/add_purchase_screen.dart';

import 'screens_test.dart' show createTestableWidget;

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  void useCompactSurface(WidgetTester tester, {double textScale = 1.0}) {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  }

  testWidgets('French Home remains readable on a compact screen', (
    tester,
  ) async {
    useCompactSurface(tester, textScale: 1.2);
    await tester.pumpWidget(
      createTestableWidget(
        child: const HomeScreen(),
        db: db,
        locale: const Locale('fr'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Budget du mois'), findsOneWidget);
    expect(find.text('Aucun article encore'), findsOneWidget);
    expect(find.text('Article le plus acheté'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 20));
  });

  testWidgets('English purchase screen renders without clipping', (tester) async {
    useCompactSurface(tester, textScale: 1.3);
    await tester.pumpWidget(
      createTestableWidget(
        child: const AddPurchaseScreen(),
        db: db,
        locale: const Locale('en'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Add purchase'), findsOneWidget);
    expect(find.text('Add item'), findsOneWidget);
    expect(find.text('Last price'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 20));
  });

  testWidgets('French Calendar uses localized labels at compact width', (
    tester,
  ) async {
    useCompactSurface(tester, textScale: 1.15);
    await tester.pumpWidget(
      createTestableWidget(
        child: const CalendarScreen(),
        db: db,
        locale: const Locale('fr'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Calendrier'), findsOneWidget);
    expect(find.text('Activité du jour'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 20));
  });

  test('all primary copy has Arabic, French, and English variants', () {
    final ar = AppLocalizations(const Locale('ar'));
    final fr = AppLocalizations(const Locale('fr'));
    final en = AppLocalizations(const Locale('en'));

    expect(
      {ar.addPurchaseTitle, fr.addPurchaseTitle, en.addPurchaseTitle}.length,
      3,
    );
    expect(
      {ar.noEventsMessage, fr.noEventsMessage, en.noEventsMessage}.length,
      3,
    );
    expect(
      {
        ar.noteTypeLabel('meal_idea'),
        fr.noteTypeLabel('meal_idea'),
        en.noteTypeLabel('meal_idea'),
      }.length,
      3,
    );
  });
}
