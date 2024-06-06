import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameCrashPage extends StatefulWidget {
  const GameCrashPage({Key? key}) : super(key: key);

  @override
  _GameCrashPageState createState() => _GameCrashPageState();
}

class _GameCrashPageState extends State<GameCrashPage> {
  final TextEditingController _guessController = TextEditingController();
  final TextEditingController _betController = TextEditingController();
  double _rocketValue = 1.0;
  bool _gameRunning = false;
  Timer? _timer;
  double _stopValue = 0;
  String _message = '';

  void _startGame() {
    setState(() {
      _rocketValue = 1.0;
      _gameRunning = true;
      _stopValue = 1.0 + Random().nextDouble() * 19.0;
      _message = '';
    });

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _rocketValue += 0.1;
        if (_rocketValue >= _stopValue) {
          _timer?.cancel();
          _gameRunning = false;
          _checkResult();
        }
      });
    });
  }

  void _checkResult() {
    double guess = double.tryParse(_guessController.text) ?? 0;
    double bet = double.tryParse(_betController.text) ?? 0;

    if (_rocketValue >= guess) {
      double winnings = bet * guess;
      setState(() {
        _message = 'You won ${winnings.toStringAsFixed(2)} coins!';
      });
    } else {
      setState(() {
        _message = 'You lost ${bet.toStringAsFixed(2)} coins!';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _guessController.dispose();
    _betController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crash Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rocket Value: x${_rocketValue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _guessController,
              decoration: InputDecoration(
                labelText: 'Your Guess (e.g., x1.56)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _betController,
              decoration: InputDecoration(
                labelText: 'Bet Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            _gameRunning
                ? ElevatedButton(
                    onPressed: null,
                    child: Text('Game Running...'),
                  )
                : ElevatedButton(
                    onPressed: _startGame,
                    child: Text('Start Game'),
                  ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
