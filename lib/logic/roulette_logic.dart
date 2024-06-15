import 'dart:math' as math;
import 'package:flutter/material.dart';

class RouletteLogic with ChangeNotifier {
  late AnimationController _controller;
  // double initialVelocity = 1.0 + math.Random().nextDouble() * 2;
  // double acceleration = -1.0 - math.Random().nextDouble();
  double initialVelocity = 1.0;
  double acceleration = -1.0;
  double extractedNumber = 0;
  bool completed = false;
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

  void startGameWithRandomNumber(int randomNumber) {
    _controller.reset();
    completed = false;

    int targetIndex = rouletteNumbers.indexOf(randomNumber);
    double targetAngle = targetIndex * (2 * math.pi / rouletteNumbers.length);
    double extraRotations = (1 + math.Random().nextInt(3)) * 2 * math.pi;

    _controller.duration =
        Duration(milliseconds: (1000 * initialVelocity).toInt());
    _controller.forward(from: 0);

    _controller.addListener(() {
      // final progress = _controller.value;
      // final currentAngle = (targetAngle + extraRotations) * progress;
      // extractedNumber = rouletteNumbers[((currentAngle % (2 * math.pi)) /
      //             (2 * math.pi / rouletteNumbers.length))
      //         .round() %
      //     37];

      // var t = _controller.value * (-initialVelocity / acceleration);
      // var angle =
      //     (initialVelocity * t + 0.5 * acceleration * t * t) * 2 * math.pi;
      // var finalAngle = -(math.pow(initialVelocity, 2) / acceleration) +
      //     (1 / 2) * (math.pow(initialVelocity, 2) / acceleration);
      // var finalAngleInDegree = (finalAngle * 360) % 360;
      // // var extractedNumber = rouletteNumbers[
      // //     (finalAngleInDegree / (360 / 37)).round() % 37];
      // extractedNumber =
      //     rouletteNumbers[(finalAngleInDegree / (360 / 37)).round() % 37];
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // extractedNumber = randomNumber;
        completed = true;
        notifyListeners();
      }
    });
  }

  double calculateCurrentAngle() {
    double progress = _controller.value;
    int targetIndex =
        rouletteNumbers.indexOf(extractedNumber.toInt()); // TODO temp fix
    double targetAngle = targetIndex * (2 * math.pi / rouletteNumbers.length);

    // double extraRotations = (math.Random().nextInt(3) * 2) * math.pi;
    double extraRotations = 0;

    // var t = _controller.value * (-initialVelocity / acceleration);
    // var angle = (initialVelocity * t) + 0.5 * (acceleration * math.pow(t, 2)) * 2 * math.pi;
    // return angle;

    extractedNumber = (targetAngle + extraRotations) * progress;

    return (targetAngle + extraRotations) * progress;
    // return 4 * math.pi * progress;
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}
