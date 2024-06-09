import 'dart:math' as math;
import 'package:flutter/foundation.dart';
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

  void startGameWithRandomNumber(int randomNumber) {
    _controller.reset();

    int targetIndex = rouletteNumbers.indexOf(randomNumber);
    double targetAngle = targetIndex * (2 * math.pi / rouletteNumbers.length);
    double extraRotations = (1 + math.Random().nextInt(3)) * 2 * math.pi;

    // Set a fixed duration for the animation
    _controller.duration =
        Duration(milliseconds: (1000 * initialVelocity).toInt());
    _controller.forward(from: 0);

    // Set the final target angle including extra rotations
    _controller.addListener(() {
      final progress = _controller.value;
      final currentAngle = (targetAngle + extraRotations) * progress;
      extractedNumber = rouletteNumbers[((currentAngle % (2 * math.pi)) /
                  (2 * math.pi / rouletteNumbers.length))
              .round() %
          37];

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

    // Update the extracted number when the animation is complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        extractedNumber = randomNumber;
        notifyListeners();
      }
    });
  }

  double calculateCurrentAngle() {
    double progress = _controller.value;
    int targetIndex = rouletteNumbers.indexOf(extractedNumber);
    double targetAngle = targetIndex * (2 * math.pi / rouletteNumbers.length);

    // Add between 1 and 3 full rotations to the target angle
    double extraRotations = (math.Random().nextInt(3) * 2) * math.pi;

    // var t = _controller.value * (-initialVelocity / acceleration);
    // var angle = (initialVelocity * t) + 0.5 * (acceleration * math.pow(t, 2)) * 2 * math.pi;
    // return angle;

    return (targetAngle + extraRotations) * progress;
    // return 4 * math.pi * progress;
  }

  void dispose() {
    _controller.dispose();
  }
}
