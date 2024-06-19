import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:hsma_cpd_project/logic/crash_logic.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';

// Mock-Klasse für BackendService
class MockBackendService extends Mock implements BackendService {}

// Mock-Klasse für AuthProvider
class MockAuthProvider extends Mock implements AuthProvider {}

void main() {
  group('GameCrashLogic Tests', () {
    late GameCrashLogic gameCrashLogic;
    late MockBackendService mockBackendService;
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockBackendService = MockBackendService();
      mockAuthProvider = MockAuthProvider();
      gameCrashLogic = GameCrashLogic(mockBackendService, mockAuthProvider);
    });

    tearDown(() {
      gameCrashLogic.dispose();
    });

    test(
        'startGame with valid guess and bet should update rocketValue and gameRunning',
        () async {
      // Mocking the backend service response
      when(mockBackendService.submitCrashGuess('user', 2, 10))
          .thenAnswer((_) async => {
                'crashPoint': 2.5,
                'coins': 120,
                'success': true,
                'winnings': 20,
                'message': 'You won 20 coins! The crash point was 2.5.',
              });

      // Setting up controllers with mock values
      gameCrashLogic.guessController.text = '2';
      gameCrashLogic.betController.text = '10';

      // Calling startGame method
      gameCrashLogic.startGame();

      // Advance the timer by 3 seconds
      await Future.delayed(const Duration(seconds: 3));

      // Check that rocketValue has been updated
      expect(gameCrashLogic.rocketValue, greaterThan(0));

      // Check that gameRunning is false after the game is finished
      expect(gameCrashLogic.gameRunning, false);

      // Check the message based on the result
      if (gameCrashLogic.guess <= gameCrashLogic.rocketValue) {
        expect(gameCrashLogic.message.contains('You won'), true);
      } else {
        expect(gameCrashLogic.message.contains('You lost'), true);
      }

      // Verify that updateCoins method of AuthProvider was called with correct coins
      verify(mockAuthProvider.updateCoins(100)).called(1);
    });
  });
}
