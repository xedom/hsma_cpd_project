import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';

class GameCoinFlipPage extends StatefulWidget {
  const GameCoinFlipPage({Key? key}) : super(key: key);

  @override
  GameCoinFlipPageState createState() => GameCoinFlipPageState();
}

class GameCoinFlipPageState extends State<GameCoinFlipPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _betController = TextEditingController();
  String _userGuess = '';
  String _coinResult = '';
  String _message = '';
  bool _isHeads = true;
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _betController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _flipCoin() {
    // Überprüfen Sie, ob das Wettfeld leer ist
    if (_betController.text.isEmpty) {
      setState(() {
        _message = 'Bitte geben Sie einen Wetteinsatz ein.';
      });
      return;
    }

    // Überprüfen Sie, ob der Benutzer eine Seite ausgewählt hat
    if (_userGuess.isEmpty) {
      setState(() {
        _message = 'Bitte wählen Sie eine Seite der Münze aus.';
      });
      return;
    }

    final bet = double.tryParse(_betController.text);
    if (bet == null || bet <= 0) {
      setState(() {
        _message = 'Bitte geben Sie einen gültigen Wetteinsatz ein.';
      });
      return;
    }

    // Aktualisieren Sie _isHeads und _coinResult basierend auf dem Ergebnis von Random().nextBool()
    _isHeads = Random().nextBool();
    _coinResult = _isHeads ? 'Heads' : 'Tails';

    // Vergleichen Sie _userGuess und _coinResult, um zu bestimmen, ob der Benutzer gewonnen oder verloren hat
    if (_userGuess != _coinResult) {
      _message = 'Sie haben ${bet * 2} Münzen gewonnen!';
    } else {
      _message = 'Sie haben ${bet.toStringAsFixed(2)} Münzen verloren!';
    }

    // Führen Sie die Münzwurfanimation aus
    _animationController?.reset();
    _animationController?.forward().then((_) {
      setState(() {
        _showFront = !_showFront;
      });
    });
  }

  Widget _buildCoinImage() {
    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        final angle = _animation!.value * 2 * pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        final showBack = angle > pi;

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Image.asset(
            showBack
                ? (_isHeads ? 'assets/tails.png' : 'assets/heads.png')
                : (_isHeads ? 'assets/heads.png' : 'assets/tails.png'),
            height: 300,
            width: 300,
          ),
        );
      },
    );
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
              _buildCoinImage(),
              const SizedBox(height: 20),
              Text(
                _message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Make a guess: Heads or Tails',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _userGuess = 'Heads';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _userGuess == 'Heads'
                              ? Colors.teal
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/heads.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _userGuess = 'Tails';
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _userGuess == 'Tails'
                              ? Colors.teal
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/tails.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FieldInput(
                hint: 'Bet Amount',
                controller: _betController,
                icon: Icons.attach_money,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Flip Coin',
                onPressed: _flipCoin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}