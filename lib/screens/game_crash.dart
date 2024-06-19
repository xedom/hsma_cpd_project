import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/constants.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/logic/crash_logic.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:provider/provider.dart';

class GameCrashPage extends StatefulWidget {
  const GameCrashPage({super.key});

  @override
  GameCrashPageState createState() => GameCrashPageState();
}

class GameCrashPageState extends State<GameCrashPage> {
  late GameCrashLogic logic;

  @override
  void initState() {
    super.initState();
    _initializeLogic();
  }

  void _initializeLogic() async {
    logic = GameCrashLogic(
      Provider.of<BackendService>(context, listen: false),
      Provider.of<AuthProvider>(context, listen: false),
    );
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: logic,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Consumer<GameCrashLogic>(
                      builder: (context, logic, _) {
                        return CustomPaint(
                          size: Size(
                              min(MediaQuery.of(context).size.width, 500), 300),
                          painter: RocketPathPainter(logic.rocketPath),
                        );
                      },
                    ),
                    Consumer<GameCrashLogic>(
                      builder: (context, logic, _) {
                        if (logic.rocketPath.isNotEmpty) {
                          // return Positioned(
                          //   left: logic.rocketPath.last.dx * 10,
                          //   top: 300 - (logic.rocketPath.last.dy * 10) - 60,
                          //   child: Column(
                          //     children: [
                          //       Text(
                          //         'x${logic.rocketValue.toStringAsFixed(2)}',
                          //         style: const TextStyle(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       Image.asset('assets/rocket.png',
                          //           width: 50, height: 50),
                          //     ],
                          //   ),
                          // );
                          return Container();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Consumer<GameCrashLogic>(
                  builder: (context, logic, _) {
                    return Text(
                      logic.message,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Consumer<GameCrashLogic>(
                  builder: (context, logic, _) {
                    return Text(
                      'Rocket x${logic.rocketValue.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    );
                  },
                ),
                const SizedBox(height: 20),
                FieldInput(
                  hint: 'Your Guess (e.g., x1.56)',
                  controller: logic.guessController,
                  icon: Icons.rocket_launch,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                FieldInput(
                  hint: 'Bet Amount',
                  controller: logic.betController,
                  icon: Icons.attach_money,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                Consumer<GameCrashLogic>(
                  builder: (context, logic, _) {
                    return logic.gameRunning
                        ? CustomButton(
                            label: 'Game Running...',
                            onPressed: () {},
                          )
                        : CustomButton(
                            label: 'Start Game',
                            onPressed: () async => logic.startGame(),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RocketPathPainter extends CustomPainter {
  final List<Offset> rocketPath;

  RocketPathPainter(this.rocketPath);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (rocketPath.isNotEmpty) {
      double stretchX = 200.0;
      double stretchY = 3000.0;

      final p0 = rocketPath.first;
      path.moveTo(0, size.height);
      for (final point in rocketPath) {
        path.lineTo(
          (point.dx - p0.dx) * (stretchX),
          size.height - ((point.dy - p0.dy) * stretchY),
        );
      }
    }
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      borderPaint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, size.height),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
