import 'dart:math' as math;
import 'package:flutter/material.dart';

class RouletteLogic with ChangeNotifier {
  late AnimationController _controller;

  double initialVelocity = 1.0 + math.Random().nextDouble() * 2;
  double acceleration = -1.0 - math.Random().nextDouble();
  int extractedNumber = 0;

  final List<int> rouletteNumbers = [
    0,
    26,
    3,
    35,
    12,
    28,
    7,
    29,
    18,
    22,
    9,
    31,
    14,
    20,
    1,
    33,
    16,
    24,
    5,
    10,
    23,
    8,
    30,
    11,
    36,
    13,
    27,
    6,
    34,
    17,
    25,
    2,
    21,
    4,
    19,
    15,
    32
  ];

  RouletteLogic(TickerProvider vsync) {
    _controller = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 0))
      ..addListener(_update);
  }

  void _update() {
    notifyListeners();
  }

  Animation<double> get animation => _controller;

  void startGame() {
    initialVelocity = 1.0 + math.Random().nextDouble() * 2;
    acceleration = -1.0 - math.Random().nextDouble();
    _controller.reset();
    _controller.duration =
        Duration(milliseconds: (1000 * initialVelocity).toInt());
    _controller.forward(from: 0);
  }

  double calculateCurrentAngle() {
    var t = _controller.value * (-initialVelocity / acceleration);
    var angle =
        (initialVelocity * t + 0.5 * acceleration * t * t) * 2 * math.pi;
    return angle;
  }

  int calculateExtractedNumber() {
    var finalAngle = -(math.pow(initialVelocity, 2) / acceleration) +
        (1 / 2) * (math.pow(initialVelocity, 2) / acceleration);
    var finalAngleInDegree = (finalAngle * 360) % 360;
    extractedNumber =
        rouletteNumbers[(finalAngleInDegree / (360 / 37)).round() % 37];
    return extractedNumber;
  }

  void dispose() {
    _controller.dispose();
  }
}
