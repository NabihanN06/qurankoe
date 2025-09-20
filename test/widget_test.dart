import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/main.dart';

void main() {
  testWidgets('App shows title and search bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // AppBar title
    expect(find.text('QURANKOE'), findsOneWidget);
    // Search field hint
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Cari surah...'), findsOneWidget);
  });
}