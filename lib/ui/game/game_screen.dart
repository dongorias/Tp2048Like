import 'dart:math' hide log;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2048/res/app_theme.dart';
import 'package:tp2048/ui/game/widget/game_over.dart';
import 'package:tp2048/ui/game/widget/grid_painter.dart';

import '../../controller/game_controller.dart';
import 'widget/count_down_timer.dart';

enum But {
  b2048('2048', 2048),
  b1024('1024', 1024),
  b512('512', 512),
  b256('256', 256);
  //b4('4', 4);

  const But(this.label, this.value);

  final String label;
  final double value;

  // Méthode pour obtenir la liste des valeurs sans custom
  static List<But> getStandardValues() {
    return But.values.toList();
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late GameController gameCtlre;

  @override
  void initState() {
    gameCtlre = Provider.of<GameController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ajout initial de deux tuiles
      gameCtlre.addNewTile();
    });
    super.initState();
  }

  @override
  void dispose() {
    gameCtlre.dispose();
    super.dispose();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Êtes-vous sûr de vouloir reprendre ?',
              style: context.textBody,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: context.textBody,
                ),
                child: Text(
                  'Annuler',
                  style: context.textBody,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: context.textBody,
                ),
                child: Text('Oui', style: context.textBody),
                onPressed: () {
                  gameCtlre.reset();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double tileSize = MediaQuery.of(context).size.width / 4;

    return Consumer<GameController>(builder: (context, gameCtlr, child) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: context.colorAccent,
            title: Text(
              'f2048',
              style: context.textTitle.copyWith(color: Colors.white),
            ),
            actions: [
              Text(
                "À propos",
                style: context.textCaption,
              ),
              Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/about'),
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () => gameCtlr.toggleSound(),
                    icon: Icon(
                      gameCtlr.isSoundEnabled
                          ? Icons.volume_up
                          : Icons.volume_off,
                      color:Colors.white,
                    ),
                  ))
            ],
          ),
          floatingActionButton: (gameCtlr.gameWinner || gameCtlr.gameOver)
              ? Container() // Au lieu de null, retourner un Container vide
              : FloatingActionButton(
                  child: const Icon(Icons.restart_alt),
                  onPressed: () {
                    _dialogBuilder(context);
                  },
                ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CountdownTimer(gameCtlr:  gameCtlr,),
                        Text(
                          "Coups : ${gameCtlr.moveCount}",
                          style:
                              context.textCaption.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dx > 0) {
                        gameCtlr.moveRight();
                      } else {
                        gameCtlr.moveLeft();
                      }
                    },
                    onVerticalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy > 0) {
                        gameCtlr.moveDown();
                      } else {
                        gameCtlr.moveUp();
                      }
                    },
                    child: CustomPaint(
                      size: Size(tileSize * 4, tileSize * 4),
                      painter: GridPainter(gameCtlr.board, tileSize),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<But>(
                              value: gameCtlr.levelGoal,
                              decoration: InputDecoration(
                                labelText: 'But à atteindre',
                                labelStyle: context.textBody,
                                border: const OutlineInputBorder(),
                              ),
                              items: But.values.map((But value) {
                                return DropdownMenuItem<But>(
                                  value: value,
                                  child: Text(value.label, style: context.textCaption.copyWith(
                                    color: Colors.black
                                  ),),
                                );
                              }).toList(),
                              onChanged: gameCtlr.handleValueChanged,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (gameCtlr.gameOver)
                GameOverOverlay(
                  onNewGame: () {
                    gameCtlr.gameOverReset();
                  },
                ),

              if (gameCtlre.gameWinner)
                // Overlay content
                Positioned(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Vous avez atteint le score ${gameCtlr.levelGoal.value.toInt()} ! 🎉\nSouhaitez-vous continuer à jouer ou terminer la partie ?',
                                  style: context.textCaption
                                      .copyWith(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          gameCtlre.winnerFinish();
                                        },
                                        child: const Text("Terminer")),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text("Continuer")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: ConfettiAnim(gameCtlr: gameCtlr,),
                      ),
                      Positioned(
                        right: 0,
                        child: ConfettiAnim(gameCtlr: gameCtlr,),
                      ),
                    ],
                  ),
                ),
            ],
          ));
    });
  }
}

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
