// filepath: apps/mobile_app/test/widget/bus_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chatapp_flutter/widgets/bus_widg.dart';

void main() {
  testWidgets('BusWidget shows top text and child', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BusWidget(
          topText: '493 MLADENOVAC',
          child: const Text('Inner content'),
          width: 300,
        ),
      ),
    ));

    expect(find.text('493 MLADENOVAC'), findsOneWidget);
    expect(find.text('Inner content'), findsOneWidget);
  });
}
