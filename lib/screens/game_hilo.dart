import 'dart:math';
import 'package:flutter/material.dart';

class GameHiLoPage extends StatefulWidget {
  const GameHiLoPage({super.key});

  @override
  _GameHiLoPageState createState() => _GameHiLoPageState();
}

class _GameHiLoPageState extends State<GameHiLoPage> {
  final List<String> _deck = [
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

  String _currentCard = '';
  String _nextCard = '';
  String _message = '';
  int _score = 0;
  List<String> _previousCards = [];
  final TextEditingController _betController = TextEditingController();
  int _coins = 100;

  @override
  void initState() {
    super.initState();
    _currentCard = _getRandomCard();
  }

  String _getRandomCard() {
    final random = Random();
    return _deck[random.nextInt(_deck.length)];
  }

  double _calculateProbability(bool isHigher) {
    int currentCardValue = _getCardValue(_currentCard);
    int higherCount =
        _deck.where((card) => _getCardValue(card) > currentCardValue).length;
    int lowerCount =
        _deck.where((card) => _getCardValue(card) < currentCardValue).length;

    return isHigher
        ? (higherCount / _deck.length) * 100
        : (lowerCount / _deck.length) * 100;
  }

  double _calculateJokerProbability() {
    return (1 / _deck.length) * 100;
  }

  double _calculateNumberProbability() {
    int numberCount = _deck.where((card) => _isNumber(card)).length;
    return (numberCount / _deck.length) * 100;
  }

  double _calculateFigureProbability() {
    int figureCount = _deck.where((card) => _isFigure(card)).length;
    return (figureCount / _deck.length) * 100;
  }

  double _calculateColorProbability(bool isRed) {
    int colorCount = _deck.where((card) => _isRed(card) == isRed).length;
    return (colorCount / _deck.length) * 100;
  }

  void _guess(bool isHigher) {
    setState(() {
      int bet = int.tryParse(_betController.text) ?? 0;
      if (bet > _coins || bet <= 0) {
        _message = 'Invalid bet amount';
        return;
      }
      _coins -= bet;
      _nextCard = _getRandomCard();
      int currentCardValue = _getCardValue(_currentCard);
      int nextCardValue = _getCardValue(_nextCard);

      if ((isHigher && nextCardValue > currentCardValue) ||
          (!isHigher && nextCardValue < currentCardValue)) {
        _score++;
        _coins += bet * 2;
        _message = 'Correct! You won $bet coins.';
      } else {
        _score = 0;
        _message = 'Wrong! You lost $bet coins.';
      }
      _previousCards.add(_currentCard);
      if (_previousCards.length > 10) {
        _previousCards.removeAt(0);
      }
      _currentCard = _nextCard;
    });
  }

  void _guessJoker() {
    setState(() {
      int bet = int.tryParse(_betController.text) ?? 0;
      if (bet > _coins || bet <= 0) {
        _message = 'Invalid bet amount';
        return;
      }
      _coins -= bet;
      _nextCard = _getRandomCard();

      if (_nextCard == 'joker') {
        _score += 5; // bonus for guessing joker
        _coins += bet * 10;
        _message = 'Correct! It\'s a Joker! You won $bet coins.';
      } else {
        _score = 0;
        _message = 'Wrong! It\'s not a Joker. You lost $bet coins.';
      }
      _previousCards.add(_currentCard);
      if (_previousCards.length > 10) {
        _previousCards.removeAt(0);
      }
      _currentCard = _nextCard;
    });
  }

  void _guessNumberOrFigure(bool isNumber) {
    setState(() {
      int bet = int.tryParse(_betController.text) ?? 0;
      if (bet > _coins || bet <= 0) {
        _message = 'Invalid bet amount';
        return;
      }
      _coins -= bet;
      _nextCard = _getRandomCard();
      bool isNextCardNumber = _isNumber(_nextCard);

      if ((isNumber && isNextCardNumber) || (!isNumber && !isNextCardNumber)) {
        _score++;
        _coins += bet * 2;
        _message = 'Correct! You won $bet coins.';
      } else {
        _score = 0;
        _message = 'Wrong! You lost $bet coins.';
      }
      _previousCards.add(_currentCard);
      if (_previousCards.length > 10) {
        _previousCards.removeAt(0);
      }
      _currentCard = _nextCard;
    });
  }

  void _guessColor(bool isRed) {
    setState(() {
      int bet = int.tryParse(_betController.text) ?? 0;
      if (bet > _coins || bet <= 0) {
        _message = 'Invalid bet amount';
        return;
      }
      _coins -= bet;
      _nextCard = _getRandomCard();

      if (_isRed(_nextCard) == isRed) {
        _score++;
        _coins += bet * 2;
        _message = 'Correct! You won $bet coins.';
      } else {
        _score = 0;
        _message = 'Wrong! You lost $bet coins.';
      }
      _previousCards.add(_currentCard);
      if (_previousCards.length > 10) {
        _previousCards.removeAt(0);
      }
      _currentCard = _nextCard;
    });
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

  int _getCardValue(String card) {
    if (card == 'joker') return 14; // Joker is considered the highest value
    return int.parse(card.split('_')[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Current Card:', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Image.asset('assets/cards/$_currentCard.png', height: 300),
              const SizedBox(height: 10),
              Text(
                _message,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _betController,
                decoration: const InputDecoration(
                  labelText: 'Bet Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _guess(true),
                    child: Text(
                        'Higher (${_calculateProbability(true).toStringAsFixed(1)}%)'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _guess(false),
                    child: Text(
                        'Lower (${_calculateProbability(false).toStringAsFixed(1)}%)'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _guessJoker,
                child: Text(
                    'Joker (${_calculateJokerProbability().toStringAsFixed(1)}%)'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _guessNumberOrFigure(true),
                    child: Text(
                        'Number: 2-9 (${_calculateNumberProbability().toStringAsFixed(1)}%)'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _guessNumberOrFigure(false),
                    child: Text(
                        'Figure: JQKA (${_calculateFigureProbability().toStringAsFixed(1)}%)'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _guessColor(true),
                    child: Text(
                        'Red (${_calculateColorProbability(true).toStringAsFixed(1)}%)'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _guessColor(false),
                    child: Text(
                        'Black (${_calculateColorProbability(false).toStringAsFixed(1)}%)'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Previous Cards:', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _previousCards.reversed
                      .take(10)
                      .map((card) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Transform.translate(
                              offset: const Offset(-10, 0),
                              child: Image.asset('assets/cards/$card.png',
                                  height: 80),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              Text('Coins: $_coins',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
