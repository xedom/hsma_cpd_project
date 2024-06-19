import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/roulette_logic.dart';

class RouletteWidget extends StatefulWidget {
  final int randomNumber;
  final ValueChanged<double> onAnimationEnd;

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
      rouletteLogic.completed = false;
      rouletteLogic.startRoulette(widget.randomNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.5,
          child: OverflowBox(
            maxHeight: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: rouletteLogic.animation,
              child: Image.asset('assets/roulette.png'),
              builder: (context, child) {
                var angle = rouletteLogic.calculateCurrentAngle();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (rouletteLogic.animation.isCompleted &&
                      !rouletteLogic.completed) {
                    widget.onAnimationEnd(angle);
                    rouletteLogic.completed = true;
                  }
                });
                return Transform.rotate(angle: angle, child: child);
              },
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.3,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.035,
            height: MediaQuery.of(context).size.width * 0.035,
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
