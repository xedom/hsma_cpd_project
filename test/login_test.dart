import 'package:flutter_test/flutter_test.dart';
import 'package:hsma_cpd_project/screens/login.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:hsma_cpd_project/widgets/button_primary.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('LoginScreen Test', (WidgetTester tester) async {
    // Erstelle den LoginScreen
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Überprüfe, ob der Text 'LOGIN TO YOUR ACCOUNT' gefunden wird
    expect(find.text('LOGIN TO YOUR ACCOUNT'), findsOneWidget);

    // Überprüfe, ob die Textfelder für Benutzername und Passwort gefunden werden
    expect(find.byType(FieldInput), findsNWidgets(2));

    // Überprüfe, ob der Anmeldebutton gefunden wird
    expect(find.byType(PrimaryButton), findsOneWidget);
  });
}