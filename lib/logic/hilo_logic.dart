import 'dart:math';
import 'package:hsma_cpd_project/logic/backend.dart';

enum GuessType { higher, lower, joker, number, figure, red, black }

class HiLoLogic {
  final List<String> deck = [
    'clubs_1',
    'clubs_2',
    'clubs_3',
    'clubs_4',
    'clubs_5',
    'clubs_6',
    'clubs_7',
    'clubs_8',
    'clubs_9',
    'clubs_10',
    'clubs_11',
    'clubs_12',
    'clubs_13',
    'diamonds_1',
    'diamonds_2',
    'diamonds_3',
    'diamonds_4',
    'diamonds_5',
    'diamonds_6',
    'diamonds_7',
    'diamonds_8',
    'diamonds_9',
    'diamonds_10',
    'diamonds_11',
    'diamonds_12',
    'diamonds_13',
    'hearts_1',
    'hearts_2',
    'hearts_3',
    'hearts_4',
    'hearts_5',
    'hearts_6',
    'hearts_7',
    'hearts_8',
    'hearts_9',
    'hearts_10',
    'hearts_11',
    'hearts_12',
    'hearts_13',
    'spades_1',
    'spades_2',
    'spades_3',
    'spades_4',
    'spades_5',
    'spades_6',
    'spades_7',
    'spades_8',
    'spades_9',
    'spades_10',
    'spades_11',
    'spades_12',
    'spades_13',
    'joker'
  ];

  final BackendService _backendService;
  String currentCard = '';
  String nextCard = '';
  String message = '';
  int score = 0;
  List<String> previousCards = [];
  int coins = 100;

  HiLoLogic(this._backendService);

  Future<void> initialize() async {
    currentCard = await _backendService.getHiLoCurrentCard();
  }

  String _getRandomCard() {
    final random = Random();
    return deck[random.nextInt(deck.length)];
  }

  double calculateProbability(GuessType guessType) {
    int currentCardValue = getCardValue(currentCard);
    int count;
    switch (guessType) {
      case GuessType.higher:
        count =
            deck.where((card) => getCardValue(card) > currentCardValue).length;
        break;
      case GuessType.lower:
        count =
            deck.where((card) => getCardValue(card) < currentCardValue).length;
        break;
      case GuessType.joker:
        count = 1;
        break;
      case GuessType.number:
        count = deck.where((card) => _isNumber(card)).length;
        break;
      case GuessType.figure:
        count = deck.where((card) => _isFigure(card)).length;
        break;
      case GuessType.red:
        count = deck.where((card) => _isRed(card)).length;
        break;
      case GuessType.black:
        count = deck.where((card) => !_isRed(card)).length;
        break;
    }
    return (count / deck.length) * 100;
  }

  String getBetMultiplier(GuessType guessType) {
    switch (guessType) {
      case GuessType.joker:
        return '25x';
      case GuessType.number:
        return '1.5x';
      case GuessType.figure:
        return '3x';
      case GuessType.red:
      case GuessType.black:
        return '2x';
      case GuessType.higher:
      case GuessType.lower:
        int currentCardValue = getCardValue(currentCard);
        double probability = guessType == GuessType.higher
            ? deck
                    .where((card) => getCardValue(card) >= currentCardValue)
                    .length /
                deck.length
            : deck
                    .where((card) => getCardValue(card) <= currentCardValue)
                    .length /
                deck.length;
        double multiplier = double.parse((1 / probability).toStringAsFixed(2));
        return '${multiplier}x';
      default:
        return '2x';
    }
  }

  void guess(GuessType guessType, int bet) {
    if (bet > coins || bet <= 0) {
      message = 'Invalid bet amount';
      return;
    }
    coins -= bet;
    nextCard = _getRandomCard();
    int currentCardValue = getCardValue(currentCard);
    int nextCardValue = getCardValue(nextCard);

    bool correctGuess;
    switch (guessType) {
      case GuessType.higher:
        correctGuess = nextCardValue > currentCardValue;
        break;
      case GuessType.lower:
        correctGuess = nextCardValue < currentCardValue;
        break;
      case GuessType.joker:
        correctGuess = nextCard == 'joker';
        break;
      case GuessType.number:
        correctGuess = _isNumber(nextCard);
        break;
      case GuessType.figure:
        correctGuess = _isFigure(nextCard);
        break;
      case GuessType.red:
        correctGuess = _isRed(nextCard);
        break;
      case GuessType.black:
        correctGuess = !_isRed(nextCard);
        break;
    }

    if (correctGuess) {
      score++;
      coins += _getWinnings(guessType, bet);
      message = 'Correct! You won ${_getWinnings(guessType, bet)} coins.';
    } else {
      score = 0;
      message = 'Wrong! You lost $bet coins.';
    }
    previousCards.add(currentCard);
    if (previousCards.length > 10) {
      previousCards.removeAt(0);
    }
    currentCard = nextCard;
  }

  int _getWinnings(GuessType guessType, int bet) {
    switch (guessType) {
      case GuessType.joker:
        return bet * 10;
      case GuessType.number:
        return (bet * 1.5).round();
      case GuessType.figure:
        return bet * 3;
      case GuessType.red:
      case GuessType.black:
        return bet * 2;
      case GuessType.higher:
        int currentCardValue = getCardValue(currentCard);
        double probability =
            deck.where((card) => getCardValue(card) > currentCardValue).length /
                deck.length;
        double multiplier = double.parse((1 / probability).toStringAsFixed(2));
        return (bet * multiplier).round();
      case GuessType.lower:
        int currentCardValue = getCardValue(currentCard);
        double probability =
            deck.where((card) => getCardValue(card) < currentCardValue).length /
                deck.length;
        double multiplier = double.parse((1 / probability).toStringAsFixed(2));
        return (bet * multiplier).round();
      default:
        return bet * 2;
    }
  }

  bool _isNumber(String card) {
    if (card == 'joker') return false;
    int value = int.parse(card.split('_')[1]);
    return value >= 2 && value <= 9;
  }

  bool _isFigure(String card) {
    if (card == 'joker') return false;
    int value = int.parse(card.split('_')[1]);
    return value == 1 || value >= 11;
  }

  bool _isRed(String card) {
    return card.startsWith('hearts') || card.startsWith('diamonds');
  }

  int getCardValue(String card) {
    if (card == 'joker') return 14;
    return int.parse(card.split('_')[1]);
  }
}
