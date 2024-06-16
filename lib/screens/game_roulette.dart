import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:hsma_cpd_project/widgets/roulette_widget.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';

class GameRoulettePage extends StatefulWidget {
  const GameRoulettePage({super.key});

  @override
  GameRoulettePageState createState() => GameRoulettePageState();
}

class GameRoulettePageState extends State<GameRoulettePage> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: RouletteWidget(
                randomNumber: randomNumber,
                onAnimationEnd: _onNumberExtracted,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: 'Start Game',
              onPressed: _startGame,
            ),
            const SizedBox(height: 20),
            Text(
              'Random Number: $randomNumber',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Extracted Number: $extractedNumber',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
