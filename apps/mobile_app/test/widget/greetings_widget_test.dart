// filepath: apps/mobile_app/test/widget/greetings_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatapp_flutter/screens/greetings_screen.dart';

void main() {
  testWidgets('ResultDisplay shows default text when no response', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: ResultDisplay()));

    expect(find.text('No server response yet.'), findsOneWidget);
  });

  testWidgets('ResultDisplay shows result message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ResultDisplay(resultMessage: 'Hi')),
    );

    expect(find.text('Hi'), findsOneWidget);
  });

  testWidgets('ResultDisplay shows error message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ResultDisplay(errorMessage: 'Error happened')),
    );

    expect(find.text('Error happened'), findsOneWidget);
  });
}
