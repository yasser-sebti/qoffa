import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/widgets/qoffa_typing_box.dart';

void main() {
  group('QoffaTypingBox Widget Template Tests', () {
    testWidgets('renders general typing box with label, prefix, and suffix',
        (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QoffaTypingBox(
              label: 'Custom Value',
              controller: controller,
              prefixIcon: Icons.edit_rounded,
              suffixText: 'KG',
              hintText: 'Enter amount...',
            ),
          ),
        ),
      );

      expect(find.text('Custom Value'), findsOneWidget);
      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
      expect(find.text('KG'), findsOneWidget);
      expect(find.text('Enter amount...'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '42');
      await tester.pump();
      expect(controller.text, '42');
    });

    testWidgets('QoffaTypingBox.currency automatically formats comma grouping',
        (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QoffaTypingBox.currency(
              label: 'Price',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Price'), findsOneWidget);
      expect(find.byIcon(Icons.paid_rounded), findsOneWidget);
      expect(find.text('DA'), findsOneWidget);
      expect(find.text('000,000 ...'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '1250000');
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, '1,250,000'), findsOneWidget);
      expect(controller.text, '1,250,000');
    });

    testWidgets('tapping container requests focus on focusNode',
        (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QoffaTypingBox(
              focusNode: focusNode,
              hintText: 'Tap me',
            ),
          ),
        ),
      );

      expect(focusNode.hasFocus, isFalse);

      await tester.tap(find.byType(QoffaTypingBox));
      await tester.pumpAndSettle();

      expect(focusNode.hasFocus, isTrue);
    });
  });
}
