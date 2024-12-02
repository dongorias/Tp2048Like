import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2048/res/app_theme.dart';

import 'controller/game_controller.dart';
import 'ui/about/about_screen.dart';
import 'ui/game/game_screen.dart';
import 'ui/intro/intro_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GameController()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/intro',
        routes: {
          '/intro': (context) => const IntroScreen(),
          '/game': (context) => const GameScreen(),
          '/about': (context) => const AboutScreen(),
        },
        title: '2048 Like',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: context.colorAccent),
          useMaterial3: true,
        ),
        home: const GameScreen());
  }
}
