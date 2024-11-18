import 'dart:async';

import 'package:flutter/material.dart';

import '../game/game_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), (){
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
            // Logo
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(300))
              ),
              child: Image.asset("assets/images/logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}
