import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tp2048/res/app_theme.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../game/game_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetAnimator(
              atRestEffect: WidgetRestingEffects.swing(),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 100.0,
                  width: 100.0,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            TextAnimator(
              "TP 2048 Like",
              style: context.textBody,
              spaceDelay: Duration(seconds: 1),
            )
          ],
        ),
      ),
    );
  }
}
