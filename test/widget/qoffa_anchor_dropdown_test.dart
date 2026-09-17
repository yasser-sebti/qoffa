import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/core/widgets/qoffa_anchor_dropdown.dart';

void main() {
  group('QoffaAnchorDropdown Widget Tests', () {
    testWidgets('renders anchor builder and opens anchored dropdown on tap',
        (tester) async {
      String? selectedVal = 'piece';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaAnchorDropdown<String>(
                selectedValue: selectedVal,
                items: const [
                  QoffaDropdownMenuItem(value: 'kg', label: 'Kilogram'),
                  QoffaDropdownMenuItem(value: 'g', label: 'Gram'),
                  QoffaDropdownMenuItem(value: 'piece', label: 'Piece'),
                ],
                onSelected: (val) {
                  selectedVal = val;
                },
                builder: (context, showDropdown) => ElevatedButton(
                  onPressed: showDropdown,
                  child: Text(selectedVal == 'piece' ? 'Piece' : (selectedVal ?? 'Select')),
                ),
              ),
            ),
          ),
        ),
      );

      // Initially only anchor button is visible
      expect(find.text('Piece'), findsOneWidget);
      expect(find.text('Kilogram'), findsNothing);

      // Tap button to open dropdown
      await tester.tap(find.text('Piece'));
      await tester.pumpAndSettle();

      // Now all items are visible in the dropdown
      expect(find.text('Kilogram'), findsOneWidget);
      expect(find.text('Gram'), findsOneWidget);
      expect(find.text('Piece'), findsNWidgets(2)); // Anchor and menu item

      // Select 'Kilogram'
      await tester.tap(find.text('Kilogram'));
      await tester.pumpAndSettle();

      // Dialog is dismissed and value updated
      expect(selectedVal, 'kg');
      expect(find.text('Gram'), findsNothing);
    });

    testWidgets('calculates exact height with zero bottom gap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaAnchorDropdown<String>(
                selectedValue: 'piece',
                itemHeight: 46.0,
                items: const [
                  QoffaDropdownMenuItem(value: 'kg', label: 'Kilogram'),
                  QoffaDropdownMenuItem(value: 'g', label: 'Gram'),
                  QoffaDropdownMenuItem(value: 'l', label: 'Liter'),
                  QoffaDropdownMenuItem(value: 'piece', label: 'Piece'),
                ],
                onSelected: (_) {},
                child: const Text('Open Menu'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Verify SingleChildScrollView exists and has exact height and zero padding
      final scrollFinder = find.byType(SingleChildScrollView);
      expect(scrollFinder, findsOneWidget);
      final scrollView = tester.widget<SingleChildScrollView>(scrollFinder);
      expect(scrollView.padding, EdgeInsets.zero);
      expect(tester.getSize(scrollFinder).height, 184.0);
    });

    testWidgets('supports mouse hover highlighting', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaAnchorDropdown<String>(
                selectedValue: 'kg',
                items: const [
                  QoffaDropdownMenuItem(value: 'kg', label: 'Kilogram'),
                  QoffaDropdownMenuItem(value: 'g', label: 'Gram'),
                ],
                onSelected: (_) {},
                child: const Text('Open Menu'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Menu'));
      await tester.pumpAndSettle();

      // Move mouse over 'Gram'
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      final gramCenter = tester.getCenter(find.text('Gram'));
      await gesture.moveTo(gramCenter);
      await tester.pumpAndSettle();

      expect(find.text('Gram'), findsOneWidget);
    });
  });
}
