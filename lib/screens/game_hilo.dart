import 'package:flutter/material.dart';
import '../logic/hilo_logic.dart';

class GameHiLoPage extends StatefulWidget {
  const GameHiLoPage({super.key});

  @override
  _GameHiLoPageState createState() => _GameHiLoPageState();
}

class _GameHiLoPageState extends State<GameHiLoPage> {
  final HiLoLogic _logic = HiLoLogic();
  final TextEditingController _betController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Current Card:', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Image.asset('assets/cards/${_logic.currentCard}.png',
                  height: 300),
              const SizedBox(height: 10),
              Text(
                _logic.message,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _betController,
                decoration: const InputDecoration(
                  labelText: 'Bet Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guess(true, bet);
                      setState(() {});
                    },
                    child: Text(
                        'Higher (${_logic.calculateProbability(true).toStringAsFixed(1)}%)'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guess(false, bet);
                      setState(() {});
                    },
                    child: Text(
                        'Lower (${_logic.calculateProbability(false).toStringAsFixed(1)}%)'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  int bet = int.tryParse(_betController.text) ?? 0;
                  _logic.guessJoker(bet);
                  setState(() {});
                },
                child: Text(
                    'Joker (${_logic.calculateJokerProbability().toStringAsFixed(1)}%)'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessNumberOrFigure(true, bet);
                      setState(() {});
                    },
                    child: Text(
                        'Number: 2-9 (${_logic.calculateNumberProbability().toStringAsFixed(1)}%)'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessNumberOrFigure(false, bet);
                      setState(() {});
                    },
                    child: Text(
                        'Figure: JQKA (${_logic.calculateFigureProbability().toStringAsFixed(1)}%)'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessColor(true, bet);
                      setState(() {});
                    },
                    child: Text(
                        'Red (${_logic.calculateColorProbability(true).toStringAsFixed(1)}%)'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      int bet = int.tryParse(_betController.text) ?? 0;
                      _logic.guessColor(false, bet);
                      setState(() {});
                    },
                    child: Text(
                        'Black (${_logic.calculateColorProbability(false).toStringAsFixed(1)}%)'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Previous Cards:', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _logic.previousCards.reversed
                      .take(6)
                      .map((card) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Transform.translate(
                              offset: const Offset(-10, 0),
                              child: Image.asset('assets/cards/$card.png',
                                  height: 150),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
