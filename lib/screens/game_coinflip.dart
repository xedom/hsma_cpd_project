import 'dart:math';

import 'package:flutter/material.dart';

class GameCoinFlipPage extends StatefulWidget {
  const GameCoinFlipPage({super.key});

  @override
  _GameCoinFlipPageState createState() => _GameCoinFlipPageState();
}

class _GameCoinFlipPageState extends State<GameCoinFlipPage> {
  final TextEditingController _betController = TextEditingController();
  String _userGuess = '';
  String _coinResult = '';
  String _message = '';
  bool _isHeads = true;

  void _flipCoin() {
    setState(() {
      double bet = double.tryParse(_betController.text) ?? 0;

      _isHeads = Random().nextBool();
      _coinResult = _isHeads ? 'Heads' : 'Tails';

      if (_userGuess == _coinResult) {
        _message = 'You won ${bet * 2} coins!';
      } else {
        _message = 'You lost ${bet.toStringAsFixed(2)} coins!';
      }
    });
  }

  @override
  void dispose() {
    _betController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Flip Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Make a guess: Heads or Tails',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userGuess = 'Heads';
                    });
                  },
                  child: const Text('Heads'),
                  // style: ElevatedButton.styleFrom(
                  //   primary: _userGuess == 'Heads' ? Colors.blue : Colors.grey,
                  // ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userGuess = 'Tails';
                    });
                  },
                  child: const Text('Tails'),
                  // style: ElevatedButton.styleFrom(
                  //   primary: _userGuess == 'Tails' ? Colors.blue : Colors.grey,
                  // ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _betController,
              decoration: InputDecoration(
                labelText: 'Bet Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _flipCoin,
              child: Text('Flip Coin'),
            ),
            const SizedBox(height: 20),
            if (_coinResult.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Result: $_coinResult',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    _isHeads ? 'assets/heads.png' : 'assets/tails.png',
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20),
                  Text(_message,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
