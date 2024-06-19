import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/widgets/button_custom.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:provider/provider.dart';

enum GuessType { tails, heads, none }

class GameCoinFlipPage extends StatefulWidget {
  const GameCoinFlipPage({super.key});

  @override
  GameCoinFlipPageState createState() => GameCoinFlipPageState();
}

class GameCoinFlipPageState extends State<GameCoinFlipPage>
    with SingleTickerProviderStateMixin {
  BackendService? _backendService;
  AuthProvider? _authProvider;
  final TextEditingController _betController = TextEditingController();
  GuessType? _userGuess;
  String _message = '';
  bool _isHead = true;
  bool _isHeadPrevious = true;
  bool _isCompleted = false;
  AnimationController? _animationController;
  Animation<double>? _animation;

  Future<void> _initialize() async {
    _backendService = Provider.of<BackendService>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void initState() {
    _initialize();
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

  void _flipCoin() async {
    _isCompleted = false;
    // Überprüfen Sie, ob das Wettfeld leer ist
    if (_betController.text.isEmpty) {
      setState(() {
        _message = 'Bitte geben Sie einen Wetteinsatz ein.';
      });
      return;
    }

    // Überprüfen Sie, ob der Benutzer eine Seite ausgewählt hat
    if (_userGuess == null) {
      setState(() {
        _message = 'Bitte wählen Sie eine Seite der Münze aus.';
      });
      return;
    }

    final bet = int.tryParse(_betController.text);
    if (bet == null || bet <= 0) {
      setState(() {
        _message = 'Bitte geben Sie einen gültigen Wetteinsatz ein.';
      });
      return;
    }

    final result = await _backendService!
        .submitCoinFlipGuess(_authProvider!.currentUser!, _userGuess!, bet);

    // Aktualisieren Sie die Münzen im AuthProvider
    _authProvider!.updateCoins(result['coins']);

    setState(() {
      _isHead = result['success']
          ? _userGuess == GuessType.heads
          : _userGuess == GuessType.tails;
    });

    // Vergleichen Sie _userGuess und _coinResult, um zu bestimmen, ob der Benutzer gewonnen oder verloren hat
    if (result['success']) {
      _message = 'Sie haben ${bet * 2} Münzen gewonnen!';
    } else {
      _message = 'Sie haben ${bet.toStringAsFixed(2)} Münzen verloren!';
    }

    // Führen Sie die Münzwurfanimation aus
    _animationController?.reset();
    _animationController?.forward();
  }

  Widget _buildCoinImage() {
    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        final progress = _animation!.value;

        final shouldSwitch = _isHeadPrevious == _isHead ? 2 : 3;

        final angle = (progress * pi * shouldSwitch) % (2 * pi);
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        bool showBack = angle >= pi / 2 && angle < 3 * pi / 2;

        if (_animation!.isCompleted && !_isCompleted) {
          showBack = _isHeadPrevious == _isHead ? showBack : !showBack;
          _isHeadPrevious = _isHead;
          _isCompleted = true;
        }

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Image.asset(
            showBack
                ? (_isHeadPrevious
                    ? 'assets/coin_tails.png'
                    : 'assets/coin_heads.png')
                : (_isHeadPrevious
                    ? 'assets/coin_heads.png'
                    : 'assets/coin_tails.png'),
            height: 250,
            width: 250,
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
              _buildCoinImage(),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _userGuess = GuessType.heads;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _userGuess == GuessType.heads
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
                        _userGuess = GuessType.tails;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _userGuess == GuessType.tails
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
                controller: _betController,
                icon: Icons.attach_money,
                keyboardType: const TextInputType.numberWithOptions(),
              ),
              const SizedBox(height: 10),
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
