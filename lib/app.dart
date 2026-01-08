import 'package:flutter/material.dart';
import 'package:math_pet/features/game/presentation/pages/game_page.dart';

class MathPetApp extends StatelessWidget {
  const MathPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathPet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}
