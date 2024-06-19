import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';

enum GuessType { tails, heads, none }

class CoinFlipLogic with ChangeNotifier {
  final BackendService backendService;
  final AuthProvider authProvider;
  final TextEditingController betController = TextEditingController();
  GuessType? userGuess;
  String message = '';
  bool isHead = true;
  bool isHeadPrevious = true;
  bool isCompleted = false;
  AnimationController? animationController;
  Animation<double>? animation;

  CoinFlipLogic(this.backendService, this.authProvider, TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController!)
      ..addListener(() {
        notifyListeners();
      });
  }

  // Future<void> initialize() async {}

  @override
  void dispose() {
    betController.dispose();
    animationController?.dispose();
    super.dispose();
  }

  void flipCoin() async {
    isCompleted = false;
    if (betController.text.isEmpty) {
      message = 'Please enter a bet amount.';
      notifyListeners();
      return;
    }

    if (userGuess == null) {
      message = 'Please choose a side of the coin.';
      notifyListeners();
      return;
    }

    final bet = int.tryParse(betController.text);
    if (bet == null || bet <= 0) {
      message = 'Please enter a valid bet amount.';
      notifyListeners();
      return;
    }

    final result = await backendService.submitCoinFlipGuess(
        authProvider.currentUser!, userGuess!, bet);
    authProvider.updateCoins(result['coins']);

    isHead = result['success']
        ? userGuess == GuessType.heads
        : userGuess == GuessType.tails;

    if (result['success']) {
      message = 'You won ${bet * 2} coins!';
    } else {
      message = 'You lost ${bet.toStringAsFixed(2)} coins!';
    }

    animationController?.reset();
    animationController?.forward();
    notifyListeners();
  }
}
