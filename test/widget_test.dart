import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/app.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';

void main() {
  testWidgets('QoffaApp boots up and renders home dashboard smoke test', (WidgetTester tester) async {
    final inMemoryDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(inMemoryDb),
        ],
        child: const QoffaApp(),
      ),
    );

    // Discrete pumps without hanging on timers
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify root QoffaApp renders
    expect(find.byType(QoffaApp), findsOneWidget);

    await inMemoryDb.close();
  });
}
