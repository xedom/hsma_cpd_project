import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/constants.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';

class GameCrashPage extends StatefulWidget {
  const GameCrashPage({super.key});

  @override
  GameCrashPageState createState() => GameCrashPageState();
}

class GameCrashPageState extends State<GameCrashPage> {
  final TextEditingController _guessController = TextEditingController();
  final TextEditingController _betController = TextEditingController();
  double _rocketValue = 0;
  bool _gameRunning = false;
  Timer? _timer;
  double _stopValue = 0;
  String _message = '';
  List<Offset> _rocketPath = [const Offset(0, 0)];
  double _guess = 0;
  double _bet = 0;

  void _startGame() {
    setState(() {
      _rocketValue = 0;
      _rocketPath = [const Offset(0, 0)];
      _gameRunning = true;

      _stopValue = _generateGeometric(0.7);

      _message = '';
      _guess = double.tryParse(_guessController.text) ?? 0;
      _bet = double.tryParse(_betController.text) ?? 0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        _rocketValue += 0.01;

        if (_rocketPath.length > 52) _rocketPath.removeAt(0);
        _rocketPath.add(Offset(
          _rocketValue * 4,
          _rocketValue * _rocketValue * 0.05,
        ));
        if (_rocketValue >= _stopValue) {
          _timer?.cancel();
          _gameRunning = false;
          _checkResult();
        }
      });
    });
  }

  double _generateGeometric(double p) {
    double u = Random().nextDouble();
    return (log(u) / log(1 - p));
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CustomPaint(
                    size:
                        Size(min(MediaQuery.of(context).size.width, 500), 300),
                    painter: RocketPathPainter(_rocketPath),
                  ),
                  if (_rocketPath.isNotEmpty)
                    Positioned(
                      left: _rocketPath.last.dx * 10,
                      top: 300 - (_rocketPath.last.dy * 10) - 60,
                      child: Column(
                        children: [
                          Text(
                            'x${_rocketValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset('assets/rocket.png',
                              width: 50, height: 50),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'Rocket x${_rocketValue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              FieldInput(
                hint: 'Your Guess (e.g., x1.56)',
                controller: _guessController,
                icon: Icons.rocket_launch,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 10),
              FieldInput(
                hint: 'Bet Amount',
                controller: _betController,
                icon: Icons.attach_money,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              _gameRunning
                  ? CustomButton(
                      label: 'Game Running...',
                      onPressed: () {},
                    )
                  : CustomButton(
                      label: 'Start Game',
                      onPressed: _startGame,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class RocketPathPainter extends CustomPainter {
  final List<Offset> rocketPath;

  RocketPathPainter(this.rocketPath);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (rocketPath.isNotEmpty) {
      double stretchX = 200.0;
      double stretchY = 3000.0;

      final p0 = rocketPath.first;
      path.moveTo(0, size.height);
      for (final point in rocketPath) {
        path.lineTo(
          (point.dx - p0.dx) * (stretchX),
          size.height - ((point.dy - p0.dy) * stretchY),
        );
      }
    }
    canvas.drawPath(path, paint);

    // Draw the border lines
    final borderPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      borderPaint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, size.height),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
