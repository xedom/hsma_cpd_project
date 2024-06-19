import 'package:flutter_test/flutter_test.dart';
import 'package:hsma_cpd_project/logic/hilo_logic.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:mocktail/mocktail.dart';

class MockBackendService extends Mock implements BackendService {}

class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  setUpAll(() {
    registerFallbackValue(GuessType.higher); // No type argument needed
  });

  group('HiLoLogic', () {
    late HiLoLogic logic;
    late MockBackendService backendService;
    late MockAuthProvider authProvider;

    setUp(() {
      backendService = MockBackendService();
      authProvider = MockAuthProvider();
      logic = HiLoLogic(backendService, authProvider);
    });

    test('initialize fetches the current card', () async {
      when(() => backendService.getHiLoCurrentCard())
          .thenAnswer((_) async => '5_hearts');

      await logic.initialize();

      expect(logic.currentCard, equals('5_hearts'));
    });

    test('getBetMultiplier returns correct multipliers', () {
      logic.currentCard = '5_hearts'; // Corrected card notation
      expect(logic.getBetMultiplier(GuessType.joker), equals('25x'));
      expect(logic.getBetMultiplier(GuessType.number), equals('1.5x'));
      expect(logic.getBetMultiplier(GuessType.figure), equals('3x'));
      expect(logic.getBetMultiplier(GuessType.red), equals('2x'));
      expect(logic.getBetMultiplier(GuessType.black), equals('2x'));
      // Adding assertions for higher and lower
      expect(logic.getBetMultiplier(GuessType.higher), isNotEmpty);
      expect(logic.getBetMultiplier(GuessType.lower), isNotEmpty);
    });

    test('guess updates the game state correctly when guess is correct',
        () async {
      logic.currentCard = '5_hearts';
      when(() => backendService.submitHiLoGuess(any(), any(), any()))
          .thenAnswer((_) async => {
                'nextCard': '6_hearts',
                'success': true,
                'winnings': 100,
                'coins': 500,
              });

      when(() => authProvider.currentUser).thenReturn('testUser');
      when(() => authProvider.updateCoins(any())).thenReturn(null);

      await logic.guess(GuessType.higher, 50);

      expect(logic.currentCard, equals('6_hearts'));
      expect(logic.message, equals('Correct! You won 100 coins.'));
      expect(logic.previousCards.last, equals('5_hearts'));
      verify(() => authProvider.updateCoins(500)).called(1);
    });

    test('guess updates the game state correctly when guess is incorrect',
        () async {
      logic.currentCard = '5_hearts';
      when(() => backendService.submitHiLoGuess(any(), any(), any()))
          .thenAnswer((_) async => {
                'nextCard': '4_hearts',
                'success': false,
                'winnings': 0,
                'coins': 450,
              });

      when(() => authProvider.currentUser).thenReturn('testUser');
      when(() => authProvider.updateCoins(any())).thenReturn(null);

      await logic.guess(GuessType.higher, 50);

      expect(logic.currentCard, equals('4_hearts'));
      expect(logic.message, equals('Wrong! You lost 50 coins.'));
      expect(logic.previousCards.last, equals('5_hearts'));
      verify(() => authProvider.updateCoins(450)).called(1);
    });
  });
}
