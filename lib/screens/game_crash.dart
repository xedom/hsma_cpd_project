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
  double _rocketValue = 0;
  bool _gameRunning = false;
  Timer? _timer;
  double _stopValue = 0;
  String _message = '';
  List<FlSpot> _rocketPath = [const FlSpot(0, 1)];
  double _guess = 0;
  double _bet = 0;

  void _startGame() {
    setState(() {
      _rocketValue = 0;
      _rocketPath = [const FlSpot(0, 0)];
      _gameRunning = true;
      _stopValue = 1.0 + Random().nextDouble() * 19.0;
      _message = '';
      _guess = double.tryParse(_guessController.text) ?? 0;
      _bet = double.tryParse(_betController.text) ?? 0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _rocketValue += 0.1;
        _rocketPath
            .add(FlSpot(_rocketValue, _rocketValue * _rocketValue * 0.05));
        if (_rocketValue >= _stopValue) {
          _timer?.cancel();
          _gameRunning = false;
          _checkResult();
        }
      });
    });
  }

  void _checkResult() {
    if (_rocketValue >= _guess) {
      double winnings = _bet * _guess;
      setState(() {
        _message = 'You won ${winnings.toStringAsFixed(2)} coins!';
      });
    } else {
      setState(() {
        _message = 'You lost ${_bet.toStringAsFixed(2)} coins!';
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
      // appBar: AppBar(title: const Text('Crash Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.8,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: _rocketValue + 1,
                      minY: 0,
                      maxY: _rocketValue + 1,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _rocketPath,
                          isCurved: true,
                          color: const Color.fromARGB(255, 0, 255, 191),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(40, 30, 170, 255),
                              Color.fromARGB(255, 0, 255, 255),
                            ],
                          ),
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(),
                        rightTitles: AxisTitles(
                          axisNameSize: 1,
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 50,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
                if (_rocketPath.isNotEmpty)
                  Positioned(
                    // left: (_rocketPath.last.x / 35) *
                    //     MediaQuery.of(context).size.width,
                    // top: (1 - _rocketPath.last.y / 15) *
                    //     (MediaQuery.of(context).size.height / 2.1),

                    left: _rocketPath.last.x,
                    top: _rocketPath.last.y,
                    child: Image.asset(
                      'assets/rocket.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Rocket Value: x${_rocketValue.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            _gameRunning
                ? const ElevatedButton(
                    onPressed: null,
                    child: Text('Game Running...'),
                  )
                : ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('Start Game'),
                  ),
          ],
        ),
      ),
    );
  }
}
