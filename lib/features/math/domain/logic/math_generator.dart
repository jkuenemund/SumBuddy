import 'dart:math';
import 'package:math_pet/features/math/domain/entities/math_problem.dart';

/// Generates random math problems.
class MathGenerator {
  final Random _rng = Random();

  /// Generates a simple addition problem (Sum <= 20).
  /// Returns a [MathProblem] with 3 choices (1 Correct, 2 Wrong).
  MathProblem generateAdditionProblem() {
    // 1. Generate Logic
    // a + b = c
    // simple constraint: a,b > 0, sum <= 20
    final a = _rng.nextInt(10) + 1; // 1-10
    final b = _rng.nextInt(10) + 1; // 1-10
    final solution = a + b;

    // 2. Generate Distractors (Wrong Answers)
    final choices = <int>{solution}; // Set to avoid duplicates via logic

    while (choices.length < 3) {
      // Create a wrong answer close to the real solution (+- 1 to 3)
      final offset = _rng.nextInt(3) + 1; // 1-3
      final sign = _rng.nextBool() ? 1 : -1;
      final wrong = solution + (offset * sign);

      // Ensure positive and typically non-zero for simplicity
      // (though 0 is valid math)
      if (wrong >= 0) {
        choices.add(wrong);
      }
    }

    // 3. Shuffle choices
    final choicesList = choices.toList()..shuffle(_rng);

    return MathProblem(
      term: '$a + $b',
      solution: solution,
      choices: choicesList,
    );
  }
}
