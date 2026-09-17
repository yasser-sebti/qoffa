import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/app.dart';
import 'package:qoffa/features/purchases/presentation/add_purchase_screen.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';

void main() {
  testWidgets('Bottom navbar remains visible on Add Product page with grayed out add button', (
    WidgetTester tester,
  ) async {
    final inMemoryDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(inMemoryDb)],
        child: const QoffaApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Initially on Home tab: navbar items exist
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('إضافة'), findsOneWidget);

    // Tap Add button in navbar to go to Add Purchase page
    await tester.tap(find.text('إضافة'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify Add Product page is shown
    expect(find.byType(AddPurchaseScreen), findsOneWidget);

    // Verify navbar items are STILL visible on Add Product page
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('التقويم'), findsOneWidget);
    expect(find.text('إضافة'), findsOneWidget);
    expect(find.text('لاحقاً'), findsOneWidget);
    expect(find.text('الدفتر'), findsOneWidget);

    // Verify the add button icon inside the circular button has the muted/grayed out color
    final iconFinder = find.byWidgetPredicate(
      (w) => w is Icon && w.icon == Icons.add_rounded && w.size == 29,
    );
    expect(iconFinder, findsOneWidget);
    final iconWidget = tester.widget<Icon>(iconFinder);
    expect(iconWidget.color, equals(const Color(0xFF8FA397)));

    // Switch back to Home by tapping 'الرئيسية'
    await tester.tap(find.text('الرئيسية'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    // Verify Home tab is active and add button is vibrant green again
    final restoredIconWidget = tester.widget<Icon>(iconFinder);
    expect(restoredIconWidget.color, equals(Colors.white));

    await inMemoryDb.close();
  });
}
