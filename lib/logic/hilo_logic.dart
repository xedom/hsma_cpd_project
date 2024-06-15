import 'dart:math';

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

  String currentCard = '';
  String nextCard = '';
  String message = '';
  int score = 0;
  List<String> previousCards = [];
  int coins = 100;

  HiLoLogic() {
    currentCard = _getRandomCard();
  }

  String _getRandomCard() {
    final random = Random();
    return deck[random.nextInt(deck.length)];
  }

  double calculateProbability(bool isHigher) {
    int currentCardValue = getCardValue(currentCard);
    int higherCount =
        deck.where((card) => getCardValue(card) > currentCardValue).length;
    int lowerCount =
        deck.where((card) => getCardValue(card) < currentCardValue).length;

    return isHigher
        ? (higherCount / deck.length) * 100
        : (lowerCount / deck.length) * 100;
  }

  double calculateJokerProbability() {
    return (1 / deck.length) * 100;
  }

  double calculateNumberProbability() {
    int numberCount = deck.where((card) => _isNumber(card)).length;
    return (numberCount / deck.length) * 100;
  }

  double calculateFigureProbability() {
    int figureCount = deck.where((card) => _isFigure(card)).length;
    return (figureCount / deck.length) * 100;
  }

  double calculateColorProbability(bool isRed) {
    int colorCount = deck.where((card) => _isRed(card) == isRed).length;
    return (colorCount / deck.length) * 100;
  }

  void guess(bool isHigher, int bet) {
    if (bet > coins || bet <= 0) {
      message = 'Invalid bet amount';
      return;
    }
    coins -= bet;
    nextCard = _getRandomCard();
    int currentCardValue = getCardValue(currentCard);
    int nextCardValue = getCardValue(nextCard);

    if ((isHigher && nextCardValue > currentCardValue) ||
        (!isHigher && nextCardValue < currentCardValue)) {
      score++;
      coins += bet * 2;
      message = 'Correct! You won $bet coins.';
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

  void guessJoker(int bet) {
    if (bet > coins || bet <= 0) {
      message = 'Invalid bet amount';
      return;
    }
    coins -= bet;
    nextCard = _getRandomCard();

    if (nextCard == 'joker') {
      score += 5; // Bonus for guessing Joker correctly
      coins += bet * 10;
      message = 'Correct! It\'s a Joker! You won $bet coins.';
    } else {
      score = 0;
      message = 'Wrong! It\'s not a Joker. You lost $bet coins.';
    }
    previousCards.add(currentCard);
    if (previousCards.length > 10) {
      previousCards.removeAt(0);
    }
    currentCard = nextCard;
  }

  void guessNumberOrFigure(bool isNumber, int bet) {
    if (bet > coins || bet <= 0) {
      message = 'Invalid bet amount';
      return;
    }
    coins -= bet;
    nextCard = _getRandomCard();
    bool isNextCardNumber = _isNumber(nextCard);

    if ((isNumber && isNextCardNumber) || (!isNumber && !isNextCardNumber)) {
      score++;
      coins += bet * 2;
      message = 'Correct! You won $bet coins.';
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

  void guessColor(bool isRed, int bet) {
    if (bet > coins || bet <= 0) {
      message = 'Invalid bet amount';
      return;
    }
    coins -= bet;
    nextCard = _getRandomCard();

    if (_isRed(nextCard) == isRed) {
      score++;
      coins += bet * 2;
      message = 'Correct! You won $bet coins.';
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
    if (card.startsWith('hearts') || card.startsWith('diamonds')) {
      return true;
    }
    return false;
  }

  int getCardValue(String card) {
    if (card == 'joker') return 14; // Joker is considered the highest value
    return int.parse(card.split('_')[1]);
  }
}
