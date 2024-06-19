import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';

class GameCrashLogic with ChangeNotifier {
  final TextEditingController guessController = TextEditingController();
  final TextEditingController betController = TextEditingController();
  final BackendService _backendService;
  final AuthProvider _authProvider;
  double rocketValue = 0;
  bool gameRunning = false;
  Timer? timer;
  double stopValue = 0;
  String message = '';
  List<Offset> rocketPath = [const Offset(0, 0)];
  double guess = 0;
  int bet = 0;
  int coins = 0;

  GameCrashLogic(this._backendService, this._authProvider);

  void startGame() async {
    rocketValue = 0;
    rocketPath = [const Offset(0, 0)];
    gameRunning = true;

    guess = double.tryParse(guessController.text) ?? 0;
    bet = int.tryParse(betController.text) ?? 0;

    if (guess <= 0 || bet <= 0) {
      message = 'Invalid guess or bet!';
      gameRunning = false;
      notifyListeners();
      return;
    }

    final result = await _backendService.submitCrashGuess(
      _authProvider.currentUser!,
      guess,
      bet,
    );

    stopValue = result['crashPoint'];
    coins = result['coins'];

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

  void _checkResult() {
    if (guess <= rocketValue) {
      int winnings = (bet * guess).round();
      message = 'You won ${winnings.toStringAsFixed(2)} coins!';
    } else {
      message = 'You lost ${bet.toStringAsFixed(2)} coins!';
    }

    _authProvider.updateCoins(coins);
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
