import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2048/res/app_theme.dart';

import '../../../controller/game_controller.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.gameCtlr});

  final GameController gameCtlr;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with WidgetsBindingObserver {
  int _counter = 0;
  bool _isPaused = true;
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _toggleTimer();
    widget.gameCtlr.timerReset.addListener(() {
      if (widget.gameCtlr.timerReset.value) {
        _resetTimer();
        widget.gameCtlr.resetTimer(false);
      }
    });

    widget.gameCtlr.timerRestart.addListener(() {
      if (widget.gameCtlr.timerRestart.value) {
        _startTimer();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    widget.gameCtlr.removeListener(() {});
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _toggleTimer() {
    setState(() {
      if (_isPaused) {
        _startTimer();
      } else {
        _stopTimer();
      }
      _isPaused = !_isPaused;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _counter = 0;
      _isPaused = true;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      if (!_isPaused) {
        _stopTimer();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_isPaused) {
        _startTimer();
      }
    }
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
                      getTimeDisplay(_counter),
                      style: context.textCaption.copyWith(color: Colors.black),
                    ))),
              ),
            ],
          ));
    });
  }

  String getTimeDisplay(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
