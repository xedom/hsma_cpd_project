import 'dart:math';

import 'package:flutter/material.dart';

class GameHiLoPage extends StatefulWidget {
  @override
  _GameHiLoPageState createState() => _GameHiLoPageState();
}

class _GameHiLoPageState extends State<GameHiLoPage> {
  final Random random = Random();
  int number = 0;

  void spinRoulette() {
    setState(() {
      number = random.nextInt(37);
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
              number == 0 ? '00' : number.toString(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: spinRoulette,
              child: const Text('Spin'),
            ),
          ],
        ),
      ),
    );
  }
}
