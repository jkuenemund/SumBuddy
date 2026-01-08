import 'package:flutter/material.dart';
import 'package:sum_buddy/features/game/presentation/pages/game_page.dart';

class SumBuddyApp extends StatelessWidget {
  const SumBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SumBuddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}
