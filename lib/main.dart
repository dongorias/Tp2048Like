import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/game_controller.dart';
import 'ui/game/game_screen.dart';
import 'ui/game/setting_screen.dart';
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
          '/settings': (context) => const SettingScreen(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const GameScreen());
  }
}
