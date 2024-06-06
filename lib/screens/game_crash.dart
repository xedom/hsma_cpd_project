import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameCrashPage extends StatefulWidget {
  const GameCrashPage({Key? key}) : super(key: key);

  @override
  _GameCrashPageState createState() => _GameCrashPageState();
}

class _GameCrashPageState extends State<GameCrashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crash Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                throw Exception('This is a crash');
              },
              child: const Text('Crash'),
            ),
          ],
        ),
      ),
    );
  }
}
