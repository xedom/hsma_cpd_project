import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/screens/coins.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/widgets/coin_packet_card.dart';


// Erstelle einen Mock für den AuthProvider
class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  group('CoinsPage Tests', () {
    testWidgets('Test für das Hinzufügen von Münzen', (WidgetTester tester) async {
      final mockAuthProvider = MockAuthProvider();

      // Erstelle das CoinsPage Widget innerhalb eines MaterialApp-Widgets für die Navigation
      // und wickel es in einen ChangeNotifierProvider für den AuthProvider
      final testWidget = ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: MaterialApp(
          home: CoinsPage(),
        ),
      );

      // Füge das Test-Widget zum Widget-Tester hinzu
      await tester.pumpWidget(testWidget);

      // Überprüfe, ob das CoinsPage Widget vorhanden ist
      expect(find.byType(CoinsPage), findsOneWidget);

      // Überprüfe, ob die Anzahl der CoinPacketCard Widgets mit der Anzahl der Münzpakete übereinstimmt
      expect(find.byType(CoinPacketCard), findsNWidgets(CoinsPage().coinPackets.length));

      // Simuliere das Tippen auf jede CoinPacketCard
      for (var i = 0; i < CoinsPage().coinPackets.length; i++) {
        await tester.tap(find.byType(CoinPacketCard).at(i));
        await tester.pumpAndSettle();

        // Überprüfe, ob die addCoins Methode des AuthProviders aufgerufen wurde
        verify(mockAuthProvider.addCoins(CoinsPage().coinPackets[i]['amount'] as int)).called(1);
      }
    });
  });
}