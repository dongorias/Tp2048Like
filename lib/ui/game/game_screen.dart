import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tp2048/res/app_theme.dart';
import 'package:tp2048/ui/game/widget/bottom_menu.dart';
import 'package:tp2048/ui/game/widget/game_over.dart';
import 'package:tp2048/ui/game/widget/grid_painter.dart';

import '../../controller/game_controller.dart';
import 'widget/quitter_popup.dart';
import 'widget/timer.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late GameController gameController;

  @override
  void initState() {
    super.initState();
    gameController = Provider.of<GameController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ajout initial de deux tuiles
      gameController.startTimer();
      gameController.addNewTile();
      gameController.addNewTile();
    });
  }

  @override
  void dispose() {
    gameController.dispose();
    super.dispose();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: context.colorAccent,
            content: Text(
              'Êtes-vous sûr de vouloir quitter ?',
              style: context.textBody.copyWith(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: context.textBody.copyWith(color: Colors.white),
                ),
                child: Text(
                  'Annuler',
                  style: context.textBody.copyWith(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: context.textBody.copyWith(color: Colors.white),
                ),
                child: Text('Quitter',
                    style: context.textBody.copyWith(color: Colors.white)),
                onPressed: () {
                  gameController.reset();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorAccent,
        title: Text(
          'f2048',
          style: context.textTitle.copyWith(color: Colors.white),
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.info),
              ))
        ],
      ),
      body: Consumer<GameController>(builder: (context, controller, child) {
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CountdownTimer(),
                      Text(
                        "Coups : ${controller.compteurCoups}",
                        style:
                            context.textCaption.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                // SwipeDetector(
                //
                //   onSwipeUp: (offset) {
                //     moveUp();
                //     incrementCoups();
                //   },
                //   onSwipeDown: (offset) {
                //     moveDown();
                //     incrementCoups();
                //   },
                //   onSwipeLeft: (offset) {
                //     moveLeft();
                //     incrementCoups();
                //   },
                //   onSwipeRight: (offset) {
                //     moveRight();
                //     incrementCoups();
                //   },
                //   child: CustomPaint(
                //     size: Size(tileSize * 4, tileSize * 4),
                //     painter: GridPainter(board, tileSize),
                //   ),

                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx > 0) {
                      controller.moveRight();
                    } else {
                      controller.moveLeft();
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dy > 0) {
                      controller.moveDown();
                    } else {
                      controller.moveUp();
                    }
                  },
                  child: CustomPaint(
                    size: Size(tileSize * 4, tileSize * 4),
                    painter: GridPainter(controller.board, tileSize),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "But à atteindre",
                            style: context.textBody,
                          ),
                          InkWell(
                            onTap: () {
                              showBottomMenu(context);
                            },
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: context.colorAccent,
                                //borderRadius: BorderRadius.circular(20)
                              ),
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Center(
                                      child: Text(
                                    "${controller.levelGoal}",
                                    style: context.textCaption
                                        .copyWith(color: Colors.black),
                                  ))),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset("assets/svgs/ic_info.svg"),
                          SvgPicture.asset("assets/svgs/ic_setting.svg"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: controller.confettiController,
                blastDirection: pi / 2,
                // maxBlastForce: 50,
                // minBlastForce: 10,
                emissionFrequency: 0.05,
                // numberOfParticles: 50,
                gravity: 0.01,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: kBottomNavigationBarHeight, right: 20),
                child: FloatingActionButton(
                    child: const Icon(Icons.restart_alt),
                    onPressed: () {
                      _dialogBuilder(context);
                      //gameController.reset();
                    }),
              ),
            ),
            if (controller.gameOver)
              GameOverOverlay(
                onNewGame: () {
                  gameController.reset();
                  Navigator.canPop(context);
                },
              ),
          ],
        );
      }),
    );
  }
}
