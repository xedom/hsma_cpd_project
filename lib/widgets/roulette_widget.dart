import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/roulette_logic.dart';

class RouletteWidget extends StatefulWidget {
  final int randomNumber;
  final ValueChanged<int> onAnimationEnd;

  const RouletteWidget({
    super.key,
    required this.randomNumber,
    required this.onAnimationEnd,
  });

  @override
  RouletteWidgetState createState() => RouletteWidgetState();
}

class RouletteWidgetState extends State<RouletteWidget>
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
  void didUpdateWidget(covariant RouletteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.randomNumber != widget.randomNumber) {
      rouletteLogic.startGameWithRandomNumber(widget.randomNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onAnimationEnd(
                      rouletteLogic.extractedNumber.toInt()); // TODO temp fix
                });
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
