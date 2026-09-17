import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/widgets/qoffa_quantity_selector.dart';

void main() {
  group('QoffaQuantitySelector Template Widget Tests', () {
    testWidgets('renders initial value and buttons', (tester) async {
      double value = 3.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return QoffaQuantitySelector(
                  value: value,
                  min: 0.0,
                  max: 10.0,
                  onChanged: (newVal) => setState(() => value = newVal),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('increments and decrements with animated transitions',
        (tester) async {
      double value = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return QoffaQuantitySelector(
                  value: value,
                  min: 0.0,
                  max: 5.0,
                  onChanged: (newVal) => setState(() => value = newVal),
                );
              },
            ),
          ),
        ),
      );

      // Increment
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(value, 2.0);
      expect(find.text('2'), findsOneWidget);

      // Decrement
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(value, 1.0);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('enforces min threshold and disables minus button',
        (tester) async {
      double value = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return QoffaQuantitySelector(
                  value: value,
                  min: 0.0,
                  max: 5.0,
                  onChanged: (newVal) => setState(() => value = newVal),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);

      // Tap disabled minus
      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();

      expect(value, 0.0);
    });

    testWidgets('enforces max threshold and disables plus button',
        (tester) async {
      double value = 5.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return QoffaQuantitySelector(
                  value: value,
                  min: 0.0,
                  max: 5.0,
                  onChanged: (newVal) => setState(() => value = newVal),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);

      // Tap disabled plus
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();

      expect(value, 5.0);
    });

    testWidgets('supports label and custom valueFormatter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QoffaQuantitySelector(
              label: 'Weight',
              value: 2.5,
              valueFormatter: (val) => '${val.toStringAsFixed(1)} kg',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('2.5 kg'), findsOneWidget);
    });
  });
}
