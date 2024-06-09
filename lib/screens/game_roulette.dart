import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:hsma_cpd_project/widgets/roulette_widget.dart';

class GameRoulettePage extends StatefulWidget {
  const GameRoulettePage({super.key});

  @override
  _GameRoulettePageState createState() => _GameRoulettePageState();
}

class _GameRoulettePageState extends State<GameRoulettePage> {
  final math.Random random = math.Random();
  int randomNumber = 0;
  int extractedNumber = 0;

  void _startGame() {
    setState(() {
      randomNumber = random.nextInt(37);
    });
  }

  void _onNumberExtracted(int number) {
    setState(() {
      extractedNumber = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: RouletteWidget(
              randomNumber: randomNumber,
              onAnimationEnd: _onNumberExtracted,
            ),
          ),
          ElevatedButton(
            onPressed: _startGame,
            child: const Text('Start Game'),
          ),
          Text('Random Number: $randomNumber'),
          Text('Extracted Number: $extractedNumber'),
        ],
      ),
    );
  }
}
