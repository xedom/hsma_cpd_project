import 'package:flutter_test/flutter_test.dart';
import 'package:hsma_cpd_project/logic/hilo_logic.dart';

void main() {
  group('HiLoLogic', () {
    late HiLoLogic logic;

    setUp(() {
      logic = HiLoLogic();
    });

    test('Initial state is correct', () {
      expect(logic.currentCard, isNotEmpty);
      expect(logic.previousCards, isEmpty);
      expect(logic.coins, 100);
      expect(logic.score, 0);
    });

    test('Guess Higher correctly updates state', () {
      final initialCardValue = logic.getCardValue(logic.currentCard);
      logic.guess(true, 10);

      if (logic.getCardValue(logic.currentCard) > initialCardValue) {
        expect(logic.coins, 110);
        expect(logic.message, 'Correct! You won 10 coins.');
        expect(logic.score, 1);
      } else {
        expect(logic.coins, 90);
        expect(logic.message, 'Wrong! You lost 10 coins.');
        expect(logic.score, 0);
      }
    });

    test('Guess Lower correctly updates state', () {
      final initialCardValue = logic.getCardValue(logic.currentCard);
      logic.guess(false, 10);

      if (logic.getCardValue(logic.currentCard) < initialCardValue) {
        expect(logic.coins, 110);
        expect(logic.message, 'Correct! You won 10 coins.');
        expect(logic.score, 1);
      } else {
        expect(logic.coins, 90);
        expect(logic.message, 'Wrong! You lost 10 coins.');
        expect(logic.score, 0);
      }
    });

    test('Guess Joker correctly updates state', () {
      logic.guessJoker(10);

      if (logic.currentCard == 'joker') {
        expect(logic.coins, 200);
        expect(logic.message, 'Correct! It\'s a Joker! You won 10 coins.');
        expect(logic.score, 5);
      } else {
        expect(logic.coins, 90);
        expect(logic.message, 'Wrong! It\'s not a Joker. You lost 10 coins.');
        expect(logic.score, 0);
      }
    });

    test('Guess Number correctly updates state', () {
      logic.guessNumberOrFigure(true, 10);

      if (logic.getCardValue(logic.currentCard) >= 2 &&
          logic.getCardValue(logic.currentCard) <= 9) {
        expect(logic.coins, 110);
        expect(logic.message, 'Correct! You won 10 coins.');
        expect(logic.score, 1);
      } else {
        expect(logic.coins, 90);
        expect(logic.message, 'Wrong! You lost 10 coins.');
        expect(logic.score, 0);
      }
    });

    test('Guess Figure correctly updates state', () {
      logic.guessNumberOrFigure(false, 10);

      if (logic.getCardValue(logic.currentCard) == 1 ||
          logic.getCardValue(logic.currentCard) >= 11) {
        expect(logic.coins, 110);
        expect(logic.message, 'Correct! You won 10 coins.');
        expect(logic.score, 1);
      } else {
        expect(logic.coins, 90);
        expect(logic.message, 'Wrong! You lost 10 coins.');
        expect(logic.score, 0);
      }
    });

    test('Guess Color correctly updates state', () {
      logic.guessColor(true, 10);

      if (logic.currentCard.startsWith('hearts') ||
          logic.currentCard.startsWith('diamonds')) {
        expect(logic.coins, 110);
        expect(logic.message, 'Correct! You won 10 coins.');
        expect(logic.score, 1);
      } else {
        expect(logic.coins, 90);
        expect(logic.message, 'Wrong! You lost 10 coins.');
        expect(logic.score, 0);
      }
    });
  });
}
