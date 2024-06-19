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
  bool displayResult = false;

  void _onAnimationEnd(double finalAngle) {
    setState(() {
      displayResult = true;
    });
  }

  void _placeBet(BuildContext context, GuessType guess) async {
    setState(() {
      displayResult = false;
    });
    final bet = int.tryParse(_betController.text) ?? 0;

    if (bet <= 0) {
      return setState(() {
        message = 'Invalid bet amount';
        displayResult = true;
      });
    }

    final result = await RouletteLogic.guess(context, guess, bet);
    final success = result['success'] as bool;

    setState(() {
      extractedNumber = (result['extractedNumber'] as (int, GuessType)).$1;

      if (success) {
        message = 'You won ${result['winnings'] - bet} coins!';
      } else {
        message =
            'You lost $bet coins! The extracted number was $extractedNumber.';
      }
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
            const SizedBox(height: 10),
            Text(
              displayResult ? message : "",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
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
                    color: Colors.red,
                    onPressed: () => _placeBet(context, GuessType.red)),
                CustomButton(
                    label: 'Black 2x',
                    color: Colors.black,
                    onPressed: () => _placeBet(context, GuessType.black)),
                CustomButton(
                    label: 'Green 10x',
                    color: Colors.green,
                    onPressed: () => _placeBet(context, GuessType.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
