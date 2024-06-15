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
    'spades_13'
  ];

  String _currentCard = '';
  String _nextCard = '';
  String _message = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _currentCard = _getRandomCard();
  }

  String _getRandomCard() {
    final random = Random();
    return _deck[random.nextInt(_deck.length)];
  }

  void _guess(bool isHigher) {
    setState(() {
      _nextCard = _getRandomCard();
      int currentCardValue = _getCardValue(_currentCard);
      int nextCardValue = _getCardValue(_nextCard);

      if ((isHigher && nextCardValue > currentCardValue) ||
          (!isHigher && nextCardValue < currentCardValue)) {
        _score++;
        _message = 'Correct!';
      } else {
        _score = 0;
        _message = 'Wrong!';
      }
      _currentCard = _nextCard;
    });
  }

  int _getCardValue(String card) {
    return int.parse(card.split('_')[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Card:', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Image.asset('assets/cards/$_currentCard.png', height: 150),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => _guess(true), child: const Text('Higher')),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () => _guess(false), child: const Text('Lower')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
