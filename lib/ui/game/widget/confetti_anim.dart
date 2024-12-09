import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../controller/game_controller.dart';

class ConfettiAnim extends StatelessWidget {
  const ConfettiAnim({super.key, required this.gameCtlr});

  final GameController gameCtlr;

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: gameCtlr.confettiController,
      blastDirection: pi / 2,
      maxBlastForce: 50,
      minBlastForce: 10,
      emissionFrequency: 0.05,
      numberOfParticles: 50,
      blastDirectionality: BlastDirectionality.explosive,
      gravity: 0.01,
      shouldLoop: false,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple,
      ],
    );
  }
}