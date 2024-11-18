import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2048/res/app_theme.dart';

import '../../../controller/game_controller.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late GameController gameController;

  @override
  void initState() {
    gameController = Provider.of<GameController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(builder: (context, controller, child) {
      return Container(
          width: 100,
          padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2, right: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: context.colorAccent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.timer_outlined,
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffffffff)),
                    child: Center(
                        child: Text(
                      gameController.timeDisplay,
                      style: context.textCaption.copyWith(color: Colors.black),
                    ))),
              ),
            ],
          ));
    });
  }
}
