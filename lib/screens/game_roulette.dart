import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/roulette_logic.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:hsma_cpd_project/widgets/roulette_widget.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';

class GameRoulettePage extends StatefulWidget {
  const GameRoulettePage({super.key});

  @override
  GameRoulettePageState createState() => GameRoulettePageState();
}

class GameRoulettePageState extends State<GameRoulettePage> {
  final TextEditingController _betController = TextEditingController();
  int extractedNumber = 0;
  String message = '';

  void _onAnimationEnd(double finalAngle) {
    print('Final angle: $finalAngle');
    setState(() {
      message = 'Number extracted: $extractedNumber';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: RouletteWidget(
                randomNumber: extractedNumber,
                onAnimationEnd: _onAnimationEnd,
              ),
            ),
            const SizedBox(height: 20),
            FieldInput(
              hint: 'Bet Amount',
              controller: _betController,
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                CustomButton(
                  label: 'Red 2x',
                  onPressed: () => setState(() {
                    extractedNumber = RouletteLogic.guess(GuessType.red);
                  }),
                  color: Colors.red,
                ),
                CustomButton(
                  label: 'Black 2x',
                  onPressed: () => setState(() {
                    extractedNumber = RouletteLogic.guess(GuessType.black);
                  }),
                  color: Colors.black,
                ),
                CustomButton(
                  label: 'Green 10x',
                  onPressed: () => setState(() {
                    extractedNumber = RouletteLogic.guess(GuessType.green);
                  }),
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Random Number: $extractedNumber',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
