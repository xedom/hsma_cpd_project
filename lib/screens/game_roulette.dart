import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/widgets/roulette_widget.dart';

class GameRoulettePage extends StatefulWidget {
  const GameRoulettePage({super.key});

  @override
  _GameRoulettePageState createState() => _GameRoulettePageState();
}

class _GameRoulettePageState extends State<GameRoulettePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(alignment: Alignment.topCenter, child: RouletteWidget())
        ],
      ),
    );
  }
}
