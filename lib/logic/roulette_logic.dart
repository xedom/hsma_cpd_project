import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/constants.dart' as constants;
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:provider/provider.dart';

enum GuessType { red, black, green }

class RouletteLogic with ChangeNotifier {
  late AnimationController _controller;
  double initialVelocity = 1.0;
  double acceleration = -1.0;
  bool completed = false;
  final rouletteNumbers = constants.rouletteNumbers;

  RouletteLogic(TickerProvider vsync) {
    _controller = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 0))
      ..addListener(_update);
  }

  void _update() {
    notifyListeners();
  }

  Animation<double> get animation => _controller;

  static Future<Map<String, dynamic>> guess(
    BuildContext context,
    GuessType guess,
    int bet,
  ) async {
    final backend = Provider.of<BackendService>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final result = await backend.submitRouletteGuess(
      auth.currentUser!,
      guess,
      bet,
    );

    auth.updateCoins(result['coins']);

    return {
      'success': result['success'],
      'winnings': result['winnings'],
      'extractedNumber': result['extractedNumber'],
      'coins': result['coins'],
    };
  }

  void startRoulette(int randomNumber) {
    _controller.reset();

    int targetIndex = rouletteNumbers.indexWhere((x) => x.$1 == randomNumber);
    double targetAngle = targetIndex * (2 * math.pi / rouletteNumbers.length);
    double extraRotations = (1 + math.Random().nextInt(5)) * 2 * math.pi;

    acceleration = -1;
    initialVelocity =
        math.sqrt(-2 * acceleration * (targetAngle + extraRotations));

    double duration = -(initialVelocity / acceleration);

    _controller.duration = Duration(milliseconds: (1000 * duration).toInt());
    _controller.forward();

    _controller.addListener(() {});

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        notifyListeners();
      }
    });
  }

  double calculateCurrentAngle() {
    double progress = _controller.value;

    var t = progress * (-initialVelocity / acceleration);
    var angle = (initialVelocity * t) + 0.5 * (acceleration * math.pow(t, 2));
    return angle;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
