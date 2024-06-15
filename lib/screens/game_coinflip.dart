import 'dart:math';
import 'package:flutter/material.dart';

class GameCoinFlipPage extends StatefulWidget {
  const GameCoinFlipPage({super.key});

  @override
  _GameCoinFlipPageState createState() => _GameCoinFlipPageState();
}

class _GameCoinFlipPageState extends State<GameCoinFlipPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _betController = TextEditingController();
  String _userGuess = '';
  String _coinResult = '';
  String _message = '';
  bool _isHeads = true;
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool _showFront = true;
  int _rotationCount = Random().nextInt(3) + 1;

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
    setState(() {
      double bet = double.tryParse(_betController.text) ?? 0;

      _isHeads = Random().nextBool();
      _coinResult = _isHeads ? 'Heads' : 'Tails';

      if (_userGuess == _coinResult) {
        _message = 'You won ${bet * 2} coins!';
      } else {
        _message = 'You lost ${bet.toStringAsFixed(2)} coins!';
      }

      _rotationCount = 1 + Random().nextInt(3);
      _animationController?.duration =
          Duration(seconds: 1 + Random().nextInt(3));

      _animationController?.forward(from: 0).then((_) {
        setState(() {
          _showFront = !_showFront;
        });
      });
    });
  }

  Widget _buildCoinImage() {
    return AnimatedBuilder(
      animation: _animation!,
      builder: (context, child) {
        final angle = _animation!.value * 2 * pi * _rotationCount;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        final showBack = (angle % (2 * pi)) > pi;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (_coinResult.isNotEmpty)
            Column(
              children: [
                _buildCoinImage(),
                const SizedBox(height: 20),
                Text(
                  _message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Make a guess: Heads or Tails',
              style: TextStyle(fontSize: 24),
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
                  child: Image.asset(
                    'assets/heads.png',
                    height: 100,
                    width: 100,
                    color: _userGuess == 'Heads'
                        ? Colors.blue.withOpacity(0.5)
                        : null,
                    colorBlendMode: BlendMode.color,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _userGuess = 'Tails';
                    });
                  },
                  child: Image.asset(
                    'assets/tails.png',
                    height: 100,
                    width: 100,
                    color: _userGuess == 'Tails'
                        ? Colors.blue.withOpacity(0.5)
                        : null,
                    colorBlendMode: BlendMode.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _betController,
              decoration: const InputDecoration(
                labelText: 'Bet Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _flipCoin,
              child: const Text('Flip Coin'),
            ),
          ],
        ),
      ),
    );
  }
}
