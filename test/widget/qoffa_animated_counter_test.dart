import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/widgets/qoffa_animated_counter.dart';

void main() {
  group('QoffaAnimatedCounter Tests', () {
    testWidgets('renders null placeholder when value is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: null,
              style: TextStyle(fontSize: 16),
              nullPlaceholder: '— DA',
            ),
          ),
        ),
      );

      expect(find.text('— DA'), findsOneWidget);
    });

    testWidgets('formats number with comma thousands and suffix', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 12500,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );

      // Settle animation
      await tester.pumpAndSettle();
      expect(find.text('12,500 DA'), findsOneWidget);
    });

    testWidgets('animates value increase smoothly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 100,
              style: TextStyle(fontSize: 16),
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('100 DA'), findsOneWidget);

      // Update widget with higher value
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 500,
              style: TextStyle(fontSize: 16),
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Mid-way animation frame
      await tester.pump(const Duration(milliseconds: 150));
      // Settle to final value
      await tester.pumpAndSettle();
      expect(find.text('500 DA'), findsOneWidget);
    });

    testWidgets('animates value decrease smoothly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 800,
              style: TextStyle(fontSize: 16),
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('800 DA'), findsOneWidget);

      // Update widget with lower value
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 200,
              style: TextStyle(fontSize: 16),
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('200 DA'), findsOneWidget);
    });

    testWidgets('supports custom prefix and suffix', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 50,
              prefix: '+',
              suffix: '%',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('+50%'), findsOneWidget);
    });

    testWidgets('animates through rapid consecutive updates smoothly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 100,
              style: TextStyle(fontSize: 16),
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('100 DA'), findsOneWidget);

      // Rapidly update from 100 to 200 then 300 mid-flight
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 200,
              style: TextStyle(fontSize: 16),
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // Update to 300 while 200 is still animating
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QoffaAnimatedCounter(
              value: 300,
              style: TextStyle(fontSize: 16),
              duration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('300 DA'), findsOneWidget);
    });
  });
}
