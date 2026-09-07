import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Login page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pump();

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Behavior 360 sample'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
