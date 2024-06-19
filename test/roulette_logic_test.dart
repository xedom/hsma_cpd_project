import 'package:flutter_test/flutter_test.dart';
import 'package:hsma_cpd_project/logic/roulette_logic.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();  // Initialisiere die Flutter-Bindung
  group('RouletteLogic', () {
    test('startRoulette sets up the animation correctly', () {
      final rouletteLogic = RouletteLogic(const TestVSync());
      const randomNumber = 5;

      rouletteLogic.startRoulette(randomNumber);

      expect(rouletteLogic.animation.status, AnimationStatus.forward);
      expect(rouletteLogic.initialVelocity, isNotNull);
      expect(rouletteLogic.acceleration, isNotNull);
    });

    test('calculateCurrentAngle calculates the angle correctly', () {
      final rouletteLogic = RouletteLogic(const TestVSync());
      const randomNumber = 5;

      rouletteLogic.startRoulette(randomNumber);

      final angle = rouletteLogic.calculateCurrentAngle();

      expect(angle, isNotNull);
      expect(angle, isNonNegative);
    });
  });
}