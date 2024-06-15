import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hsma_cpd_project/screens/game_hilo.dart';

void main() {
  testWidgets('GameHiLoPage test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameHiLoPage()));

    expect(find.text('Current Card:'), findsOneWidget);
    expect(find.text('Bet Amount'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), '10');
    await tester.tap(find.text('Higher'));
    await tester.pump();

    // expect(find.textContaining('Correct!'), findsOneWidget);
  });
}
