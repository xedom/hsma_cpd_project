import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import '../logic/hilo_logic.dart';
import '../constants.dart';

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
      _listKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
    }
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
              const SizedBox(height: 40),
              const Text(
                'Current Card:',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset('assets/cards/${_logic.currentCard}.png', height: 300),
              const SizedBox(height: 20),
              Text(
                _logic.message,
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
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  CustomButton(
                    label: 'Higher (${_logic.calculateProbability(true).toStringAsFixed(1)}%)',
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guess(true, bet);
                      _updateState();
                    },
                  ),
                  CustomButton(
                    label: 'Lower (${_logic.calculateProbability(false).toStringAsFixed(1)}%)',
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guess(false, bet);
                      _updateState();
                    },
                  ),
                  CustomButton(
                    label: 'Joker (${_logic.calculateJokerProbability().toStringAsFixed(1)}%)',
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessJoker(bet);
                      _updateState();
                    },
                  ),
                  CustomButton(
                    label: 'Number: 2-9 (${_logic.calculateNumberProbability().toStringAsFixed(1)}%)',
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessNumberOrFigure(true, bet);
                      _updateState();
                    },
                  ),
                  CustomButton(
                    label: 'Figure: JQKA (${_logic.calculateFigureProbability().toStringAsFixed(1)}%)',
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessNumberOrFigure(false, bet);
                      _updateState();
                    },
                  ),
                  CustomButton(
                    label: 'Red (${_logic.calculateColorProbability(true).toStringAsFixed(1)}%)',
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessColor(true, bet);
                      _updateState();
                    },
                    color: Colors.red,
                  ),
                  CustomButton(
                    label: 'Black (${_logic.calculateColorProbability(false).toStringAsFixed(1)}%)',
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessColor(false, bet);
                      _updateState();
                    },
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
