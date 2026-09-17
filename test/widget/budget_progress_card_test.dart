import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/localization/app_localizations.dart';
import 'package:qoffa/core/database/app_database.dart';
import 'package:qoffa/core/database/database_provider.dart';
import 'package:qoffa/core/widgets/qoffa_animated_counter.dart';
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
  testWidgets(
      'Renders Budget and Today Spent progress card with QoffaAnimatedCounter',
      (tester) async {
    tester.view.physicalSize = const Size(412, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final inMemoryDb = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      createTestableWidget(
        child: const AddPurchaseScreen(),
        db: inMemoryDb,
        locale: const Locale('en'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Scroll to reveal the progress card
    await tester.scrollUntilVisible(
      find.text("Today's spend"),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify progress card labels are rendered
    expect(find.text("Today's spend"), findsOneWidget);
    expect(find.text('Remaining budget'), findsOneWidget);
    expect(find.textContaining('of budget'), findsOneWidget);

    // Verify QoffaAnimatedCounter widgets are used in the progress card
    expect(find.byType(QoffaAnimatedCounter), findsWidgets);

    // Verify default values (0 DA today spent, 60,000 DA remaining)
    expect(find.text('0 DA'), findsWidgets);
    expect(find.text('60,000 DA'), findsWidgets);

    await inMemoryDb.close();
    await tester.pump();
  });
}
