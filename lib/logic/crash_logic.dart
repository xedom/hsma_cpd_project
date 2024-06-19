import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameCrashLogic with ChangeNotifier {
  final TextEditingController guessController = TextEditingController();
  final TextEditingController betController = TextEditingController();
  double rocketValue = 0;
  bool gameRunning = false;
  Timer? timer;
  double stopValue = 0;
  String message = '';
  List<Offset> rocketPath = [const Offset(0, 0)];
  double guess = 0;
  double bet = 0;

  void startGame() {
    rocketValue = 0;
    rocketPath = [const Offset(0, 0)];
    gameRunning = true;
    stopValue = _generateGeometric(0.7);
    message = '';
    guess = double.tryParse(guessController.text) ?? 0;
    bet = double.tryParse(betController.text) ?? 0;
    notifyListeners();

    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      rocketValue += 0.01;
      if (rocketPath.length > 52) rocketPath.removeAt(0);
      rocketPath.add(Offset(
        rocketValue * 4,
        rocketValue * rocketValue * 0.05,
      ));
      if (rocketValue >= stopValue) {
        timer.cancel();
        gameRunning = false;
        _checkResult();
      }
      notifyListeners();
    });
  }

  double _generateGeometric(double p) {
    double u = Random().nextDouble();
    return (log(u) / log(1 - p));
  }

  void _checkResult() {
    if (rocketValue >= guess) {
      double winnings = bet * guess;
      message = 'You won ${winnings.toStringAsFixed(2)} coins!';
    } else {
      message = 'You lost ${bet.toStringAsFixed(2)} coins!';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    guessController.dispose();
    betController.dispose();
    super.dispose();
  }
}
