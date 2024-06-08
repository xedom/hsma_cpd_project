import 'dart:math' as math;
import 'package:flutter/material.dart';

class GameRoulettePage extends StatefulWidget {
  const GameRoulettePage({super.key});

  @override
  _GameRoulettePageState createState() => _GameRoulettePageState();
}

// class _GameRoulettePageState extends State<GameRoulettePage> {
//   final Random random = Random();
//   int number = 0;
//   void spinRoulette() {
//     setState(() {
//       number = random.nextInt(37);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               number == 0 ? '00' : number.toString(),
//               style: const TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: spinRoulette,
//               child: const Text('Spin'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class _GameRoulettePageState extends State<GameRoulettePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(alignment: Alignment.topCenter, child: RouletteWidget())
        ],
      ),
    );
  }
}

class RouletteWidget extends StatefulWidget {
  @override
  _RouletteWidgetState createState() => _RouletteWidgetState();
}

class _RouletteWidgetState extends State<RouletteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var initialVelocity = 1.0 + math.Random().nextDouble() * 2;
  var acceleration = -1.0 - math.Random().nextDouble();
  int extractedNumber = 0;

  var rouletteNumbers = [
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

  // @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 0));
    // ..forward();
    // ..repeat();
  }

  void startGame() {
    initialVelocity = 1.0 + math.Random().nextDouble() * 2;
    acceleration = -1.0 - math.Random().nextDouble();
    _controller.reset();
    _controller.duration =
        Duration(milliseconds: (1000 * initialVelocity).toInt());
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            FractionalTranslation(
              translation: const Offset(0, -0.5),
              child: ClipRect(
                clipper: BottomHalfClipper(),
                child: AnimatedBuilder(
                  animation: _controller,
                  child: Image.asset('assets/roulette.png'),
                  builder: (context, child) {
                    var t =
                        _controller.value * (-initialVelocity / acceleration);
                    var angle =
                        (initialVelocity * t + 0.5 * acceleration * t * t) *
                            2 *
                            math.pi;
                    var finalAngle = -(math.pow(initialVelocity, 2) /
                            acceleration) +
                        (1 / 2) * (math.pow(initialVelocity, 2) / acceleration);
                    var finalAngleInDegree = (finalAngle * 360) % 360;
                    // var extractedNumber = rouletteNumbers[
                    //     (finalAngleInDegree / (360 / 37)).round() % 37];
                    extractedNumber = rouletteNumbers[
                        (finalAngleInDegree / (360 / 37)).round() % 37];
                    // print('finalAngle is $finalAngle');
                    // print('finalAngleInDegree is $finalAngleInDegree');
                    // print('extractedNumber is $extractedNumber');
                    return Transform.rotate(angle: angle, child: child);
                  },
                ),
              ),
            ),
            Positioned(
              top: 150,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/roulette_ball.png'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: startGame,
          child: const Text('Start Game'),
        ),
        Text(
          'Extracted Number: $extractedNumber',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}

class BottomHalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, size.height / 2, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
