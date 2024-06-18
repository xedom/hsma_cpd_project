import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import '../logic/hilo_logic.dart';
import 'package:provider/provider.dart';
import 'package:hsma_cpd_project/providers/auth.dart';

class GameHiLoPage extends StatefulWidget {
  const GameHiLoPage({super.key});

  @override
  GameHiLoPageState createState() => GameHiLoPageState();
}

class GameHiLoPageState extends State<GameHiLoPage> {
  final HiLoLogic _logic = HiLoLogic();
  final TextEditingController _betController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _updateState() {
    setState(() {});
    if (_listKey.currentState != null) {
      _listKey.currentState!
          .insertItem(0, duration: const Duration(milliseconds: 300));
    }
  }

  Future<void> _saveGuess(bool isHigher,
      [bool? isJoker, bool? isNumber, bool? isRed]) async {
    int bet = int.tryParse(_betController.text) ?? 0;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? token = authProvider.token;

    // if (isJoker != null && isJoker) {
    //   await _logic.guessJoker(bet);
    // } else if (isNumber != null) {
    //   await _logic.guessNumberOrFigure(isNumber, bet);
    // } else if (isRed != null) {
    //   await _logic.guessColor(isRed, bet);
    // } else {
    //   await _logic.guess(isHigher, bet);
    // }

    _updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Text(
                'Current Card:',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset('assets/cards/${_logic.currentCard}.png',
                  height: 300),
              const SizedBox(height: 10),
              Text(
                _logic.message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              // --- user inputs ------------------------------
              FieldInput(
                hint: 'Bet Amount',
                controller: _betController,
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    label:
                        'Higher (${_logic.calculateProbability(true).toStringAsFixed(1)}%)',
                    onPressed: () => _saveGuess(true),
                  ),
                  CustomButton(
                    label:
                        'Lower (${_logic.calculateProbability(false).toStringAsFixed(1)}%)',
                    onPressed: () => _saveGuess(false),
                  ),
                  CustomButton(
                    label:
                        'Joker (${_logic.calculateJokerProbability().toStringAsFixed(1)}%)',
                    onPressed: () => _saveGuess(false, true),
                  ),
                  CustomButton(
                    label:
                        'Number: 2-9 (${_logic.calculateNumberProbability().toStringAsFixed(1)}%)',
                    onPressed: () => _saveGuess(false, false, true),
                  ),
                  CustomButton(
                    label:
                        'Figure: JQKA (${_logic.calculateFigureProbability().toStringAsFixed(1)}%)',
                    onPressed: () => _saveGuess(false, false, false),
                  ),
                  CustomButton(
                    label:
                        'Red (${_logic.calculateColorProbability(true).toStringAsFixed(1)}%)',
                    onPressed: () => _saveGuess(false, false, false, true),
                    color: Colors.red,
                  ),
                  CustomButton(
                    label:
                        'Black (${_logic.calculateColorProbability(false).toStringAsFixed(1)}%)',
                    onPressed: () => _saveGuess(false, false, false, false),
                    color: Colors.black,
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Previous Cards:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: AnimatedList(
                  key: _listKey,
                  scrollDirection: Axis.horizontal,
                  initialItemCount: _logic.previousCards.length,
                  itemBuilder: (context, index, animation) {
                    double opacity = 1.0;
                    switch (index) {
                      case 1:
                        opacity = 0.8;
                        break;
                      case 2:
                        opacity = 0.7;
                        break;
                      case 3:
                        opacity = 0.5;
                        break;
                      case 4:
                        opacity = 0.2;
                        break;
                      case 5:
                        opacity = 0.1;
                        break;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SlideTransition(
                        position: animation.drive(Tween(
                          begin: const Offset(-1, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeIn))),
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset(
                            'assets/cards/${_logic.previousCards[_logic.previousCards.length - 1 - index]}.png',
                            height: 150,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
