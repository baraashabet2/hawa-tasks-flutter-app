import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawa/main.dart';

void main() {
  testWidgets('Hawa app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const HawaApp());

    expect(find.text('يومك اليوم'), findsOneWidget);
    expect(find.text('اليوم'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}