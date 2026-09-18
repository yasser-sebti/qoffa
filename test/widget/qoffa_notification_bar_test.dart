import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qoffa/app/theme/qoffa_colors.dart';
import 'package:qoffa/core/widgets/top_toast_notification.dart';

void main() {
  group('QoffaNotificationBar Styling & Interaction Tests', () {
    testWidgets('Renders approved filled color notification with check icon and no outline',
        (tester) async {
      var dismissed = false;
      const data = QoffaNotificationData(
        id: 1,
        message: 'تم حفظ التغييرات بنجاح',
        type: QoffaNotificationType.approved,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaNotificationBar(
                data: data,
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        ),
      );

      // Verify message text is present
      expect(find.text('تم حفظ التغييرات بنجاح'), findsOneWidget);

      // Verify approved state icon (check circle)
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Verify container has filled green background and NO outline border
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(QoffaNotificationBar),
          matching: find.byType(AnimatedContainer).first,
        ),
      );
      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.color, QoffaColors.actionGreen);
      expect(decoration.border, isNull); // No outline style

      // Tap X exit button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(dismissed, isTrue);
    });

    testWidgets('Renders declined filled color notification with cancel icon and no outline',
        (tester) async {
      const data = QoffaNotificationData(
        id: 2,
        message: 'فشلت العملية، يرجى المحاولة لاحقاً',
        type: QoffaNotificationType.declined,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaNotificationBar(
                data: data,
                onDismiss: () {},
              ),
            ),
          ),
        ),
      );

      // Verify declined icon
      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(QoffaNotificationBar),
          matching: find.byType(AnimatedContainer).first,
        ),
      );
      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFDC2626));
      expect(decoration.border, isNull);
    });

    testWidgets('Renders normal filled slate color notification with info icon',
        (tester) async {
      const data = QoffaNotificationData(
        id: 3,
        message: 'هناك تحديث متاح للمنتجات',
        type: QoffaNotificationType.normal,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaNotificationBar(
                data: data,
                onDismiss: () {},
              ),
            ),
          ),
        ),
      );

      // Verify normal icon
      expect(find.byIcon(Icons.info_rounded), findsOneWidget);

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(QoffaNotificationBar),
          matching: find.byType(AnimatedContainer).first,
        ),
      );
      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF1D4ED8));
      expect(decoration.border, isNull);
    });

    testWidgets('Renders increased Inter typography with no yellow underlines',
        (tester) async {
      const data = QoffaNotificationData(
        id: 4,
        title: 'تنبيه مهم',
        message: 'تم تحديث الأسعار للمشتريات',
        type: QoffaNotificationType.approved,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaNotificationBar(
                data: data,
                onDismiss: () {},
              ),
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text('تنبيه مهم'));
      expect(titleWidget.style?.fontFamily, 'Inter');
      expect(titleWidget.style?.fontSize, greaterThanOrEqualTo(16.0));
      expect(titleWidget.style?.decoration, TextDecoration.none);

      final messageWidget =
          tester.widget<Text>(find.text('تم تحديث الأسعار للمشتريات'));
      expect(messageWidget.style?.fontFamily, 'Inter');
      expect(messageWidget.style?.fontSize, greaterThanOrEqualTo(15.0));
      expect(messageWidget.style?.decoration, TextDecoration.none);
    });

    testWidgets('Clicking highlighted word triggers redirection callback without yellow underline',
        (tester) async {
      var redirected = false;
      final data = QoffaNotificationData(
        id: 5,
        message: 'تم إضافة حليب كانديا، انتقل إلى السلة للتحقق',
        type: QoffaNotificationType.approved,
        highlights: [
          QoffaNotificationHighlight(
            word: 'انتقل إلى السلة',
            onTap: () {
              redirected = true;
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: QoffaNotificationBar(
                data: data,
                onDismiss: () {},
              ),
            ),
          ),
        ),
      );

      // Verify highlighted word widget is present
      final highlightedFinder = find.text('انتقل إلى السلة');
      expect(highlightedFinder, findsOneWidget);

      final highlightedText = tester.widget<Text>(highlightedFinder);
      expect(highlightedText.style?.decoration, TextDecoration.none);
      expect(highlightedText.style?.color, Colors.white);

      // Tap highlighted word
      await tester.tap(highlightedFinder);
      await tester.pump();

      expect(redirected, isTrue);
    });

    testWidgets('Successive notifications crossfade gracefully in TopToastLayer',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TopToastLayer(
            child: Scaffold(
              body: Center(
                child: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      QoffaToast.show(
                        message: 'First notification',
                        type: QoffaNotificationType.normal,
                      );
                    },
                    child: const Text('Show Notification'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Trigger first notification
      QoffaToast.show(
        message: 'First Notification',
        type: QoffaNotificationType.normal,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('First Notification'), findsOneWidget);
      expect(find.byIcon(Icons.info_rounded), findsOneWidget);

      // Trigger second notification while first is active
      QoffaToast.show(
        message: 'Second Notification Approved',
        type: QoffaNotificationType.approved,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 320));

      // Second notification is now fully displayed in the same breathing notification bar
      expect(find.text('Second Notification Approved'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Verify the animated background container transitioned to approved green color
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(QoffaNotificationBar),
          matching: find.byType(AnimatedContainer).first,
        ),
      );
      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.color, QoffaColors.actionGreen);

      // Dismiss using X button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Notification is completely dismissed
      expect(find.byType(QoffaNotificationBar), findsNothing);
    });
  });
}
