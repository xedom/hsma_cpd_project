import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/roulette_logic.dart';

class RouletteWidget extends StatefulWidget {
  @override
  _RouletteWidgetState createState() => _RouletteWidgetState();
}

class _RouletteWidgetState extends State<RouletteWidget>
    with SingleTickerProviderStateMixin {
  late RouletteLogic rouletteLogic;

  @override
  void initState() {
    super.initState();
    rouletteLogic = RouletteLogic(this);
  }

  @override
  void dispose() {
    rouletteLogic.dispose();
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
                clipper: HalfClipper(),
                child: AnimatedBuilder(
                  animation: rouletteLogic.animation,
                  child: Image.asset('assets/roulette.png'),
                  builder: (context, child) {
                    var angle = rouletteLogic.calculateCurrentAngle();
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
          onPressed: rouletteLogic.startGame,
          child: const Text('Start Game'),
        ),
        AnimatedBuilder(
          animation: rouletteLogic.animation,
          builder: (context, child) {
            return Text(
              'Extracted Number: ${rouletteLogic.extractedNumber}',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ],
    );
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, size.height / 2, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
