import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GameCrashPage extends StatefulWidget {
  const GameCrashPage({super.key});

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
  List<FlSpot> _rocketPath = [const FlSpot(0, 1)];

  void _startGame() {
    setState(() {
      _rocketValue = 1.0;
      _gameRunning = true;
      _stopValue = 1.0 +
          Random().nextDouble() *
              19.0; // Random stop value between 1.0 and 20.0
      _message = '';
      _rocketPath = [const FlSpot(0, 1)];
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _rocketValue += 0.1;
        _rocketPath.add(FlSpot(_rocketValue,
            _rocketValue * _rocketValue * 0.05)); // Apply curve effect
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
        title: const Text('Crash Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rocket Value: x${_rocketValue.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _guessController,
              decoration: const InputDecoration(
                labelText: 'Your Guess (e.g., x1.56)',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _betController,
              decoration: const InputDecoration(
                labelText: 'Bet Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            _gameRunning
                ? const ElevatedButton(
                    onPressed: null,
                    child: Text('Game Running...'),
                  )
                : ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('Start Game'),
                  ),
            const SizedBox(height: 20),
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.7,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 20,
                      minY: 1,
                      maxY: 20,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _rocketPath,
                          isCurved: true,
                          // colors: [Colors.green],
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(),
                        bottomTitles: AxisTitles(),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.black),
                      ),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
                if (_rocketPath.isNotEmpty)
                  Positioned(
                    left: (_rocketPath.last.x / 35) *
                        MediaQuery.of(context).size.width,
                    top: (1 - _rocketPath.last.y / 15) *
                        (MediaQuery.of(context).size.height / 2.1),
                    child: Image.asset(
                      'assets/rocket.png',
                      width: 5,
                      height: 5,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
