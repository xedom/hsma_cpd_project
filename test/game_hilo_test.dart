import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hsma_cpd_project/screens/game_hilo.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';

// Mock BackendService for testing
class MockBackendService extends Mock implements BackendService {}
class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  group('GameHiLoPage Widget Tests', () {
    // Test for checking if the page loads and shows the current card image
    testWidgets('GameHiLoPage shows current card image when loaded', (WidgetTester tester) async {
      // Create mock instances of BackendService and AuthProvider
      final mockBackendService = MockBackendService();
      final mockAuthProvider = MockAuthProvider();

      // Provide mock instances to the widget tree using ChangeNotifierProvider
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<BackendService>.value(value: mockBackendService),
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ],
          child: MaterialApp(
            home: GameHiLoPage(),
          ),
        ),
      );

      // Simulate initialization completion
      when(mockBackendService.getHiLoCurrentCard()).thenAnswer((_) async => '2_club');

      // Trigger initial build
      await tester.pump();

      // Wait for loading indicator to disappear
      await tester.pumpAndSettle();

      // Verify that the current card image is displayed
      expect(find.text('Current Card:'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is Image && widget.image is AssetImage), findsOneWidget);
    });

    // Add more tests for interactions and state changes as needed
  });
}