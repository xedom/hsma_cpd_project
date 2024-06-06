import 'dart:math';

import 'package:flutter/material.dart';

class GameCoinFlipPage extends StatefulWidget {
  const GameCoinFlipPage({super.key});

  @override
  _GameCoinFlipPageState createState() => _GameCoinFlipPageState();
}

class _GameCoinFlipPageState extends State<GameCoinFlipPage> {
  final Random random = Random();
  bool isHeads = true;

  void flipCoin() {
    setState(() {
      isHeads = random.nextBool();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isHeads ? 'Heads' : 'Tails',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: flipCoin,
              child: const Text('Flip'),
            ),
          ],
        ),
      ),
    );
  }
}
