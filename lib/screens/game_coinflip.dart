import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/logic/coinflip_logic.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:provider/provider.dart';

class GameCoinFlipPage extends StatefulWidget {
  const GameCoinFlipPage({super.key});

  @override
  GameCoinFlipPageState createState() => GameCoinFlipPageState();
}

class GameCoinFlipPageState extends State<GameCoinFlipPage>
    with SingleTickerProviderStateMixin {
  late CoinFlipLogic coinFlipLogic;

  @override
  void initState() {
    super.initState();
    final backendService = Provider.of<BackendService>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    coinFlipLogic = CoinFlipLogic(backendService, authProvider, this);
  }

  @override
  void dispose() {
    coinFlipLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coinFlipLogic,
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
                Consumer<CoinFlipLogic>(
                  builder: (context, logic, _) {
                    return _buildCoinImage(logic);
                  },
                ),
                const SizedBox(height: 10),
                Consumer<CoinFlipLogic>(
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
                const SizedBox(height: 20),
                const Text(
                  'Make a guess: Heads or Tails',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          coinFlipLogic.userGuess = GuessType.heads;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: coinFlipLogic.userGuess == GuessType.heads
                                ? Colors.teal
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Image.asset(
                          'assets/coin_heads.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          coinFlipLogic.userGuess = GuessType.tails;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: coinFlipLogic.userGuess == GuessType.tails
                                ? Colors.teal
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Image.asset(
                          'assets/coin_tails.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FieldInput(
                  hint: 'Bet Amount',
                  controller: coinFlipLogic.betController,
                  icon: Icons.attach_money,
                  keyboardType: const TextInputType.numberWithOptions(),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  label: 'Flip Coin',
                  onPressed: coinFlipLogic.flipCoin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoinImage(CoinFlipLogic logic) {
    return AnimatedBuilder(
      animation: logic.animation!,
      builder: (context, child) {
        final progress = logic.animation!.value;

        final shouldSwitch = logic.isHeadPrevious == logic.isHead ? 2 : 3;

        final angle = (progress * pi * shouldSwitch) % (2 * pi);
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        bool showBack = angle >= pi / 2 && angle < 3 * pi / 2;

        if (logic.animation!.isCompleted && !logic.isCompleted) {
          showBack =
              logic.isHeadPrevious == logic.isHead ? showBack : !showBack;
          logic.isHeadPrevious = logic.isHead;
          logic.isCompleted = true;
        }

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Image.asset(
            showBack
                ? (logic.isHeadPrevious
                    ? 'assets/coin_tails.png'
                    : 'assets/coin_heads.png')
                : (logic.isHeadPrevious
                    ? 'assets/coin_heads.png'
                    : 'assets/coin_tails.png'),
            height: 250,
            width: 250,
          ),
        );
      },
    );
  }
}
