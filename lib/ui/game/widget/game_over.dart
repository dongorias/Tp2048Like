import 'package:flutter/material.dart';
import 'package:tp2048/res/app_theme.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onNewGame;

  const GameOverOverlay({
    super.key,
    required this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: Container(
                color: Colors.black.withOpacity(
          0.7,
        ))),
        Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.sizeOf(context).height / 3,
          child: Text(
              textAlign: TextAlign.center,
              'Game Over!',
              style: context.textTitle.copyWith(color: Colors.white)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            child: ElevatedButton(
              onPressed: onNewGame,
              child: const Text('Nouvelle Partie'),
            ),
          ),
        ),
      ],
    );
  }
}
