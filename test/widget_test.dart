// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:only_vets_client/main.dart';
import 'package:only_vets_client/notification_page.dart';

void main() {
  testWidgets('Test widget', (WidgetTester tester) async {
    // Build your widget under test wrapped in a MaterialApp
    await tester.pumpWidget(MaterialApp(
      home: NotificationPage(message: null,), // Example: Replace with your widget under test
    ));

    // Example test: Check if a widget with specific text is present
    expect(find.text('Notification'), findsOneWidget);
  });
}
