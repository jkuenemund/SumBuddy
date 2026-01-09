import 'dart:math';
import 'package:sum_buddy/features/math/domain/entities/math_difficulty.dart';
import 'package:sum_buddy/features/math/domain/entities/math_input_type.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';
import 'package:sum_buddy/features/math/domain/entities/math_problem.dart';

/// Stateless logic for generating math problems based on difficulty.
class MathGenerator {
  static final _random = Random();

  /// Generates a single problem based on the provided difficulty settings.
  static MathProblem generate(MathDifficulty difficulty) {
    int a;
    int b;
    int solution;
    String term;

    switch (difficulty.operation) {
      case MathOperation.addition:
        a =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;
        b =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;
        solution = a + b;
        term = '$a + $b';

      case MathOperation.subtraction:
        a =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;
        b =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;

        // Swap if we need positive results and b > a
        if (difficulty.ensurePositiveResult && b > a) {
          final temp = a;
          a = b;
          b = temp;
        }

        solution = a - b;
        term = '$a - $b';

      case MathOperation.multiplication:
        a =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;
        b =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;
        solution = a * b;
        term = '$a × $b';

      case MathOperation.division:
        // For division, we generate the result (res) and the divisor (b)
        // then calculate a = b * res
        final res =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;
        b =
            _random.nextInt(difficulty.maxOperand - difficulty.minOperand + 1) +
            difficulty.minOperand;
        a = res * b;
        solution = res;
        term = '$a ÷ $b';
    }

    // Generate Distractors (Wrong Answers) for Multiple Choice
    final choices = <int>[];
    if (difficulty.inputType == MathInputType.multipleChoice) {
      choices.add(solution);
      while (choices.length < 3) {
        final distractor = solution + _random.nextInt(7) - 3;
        if (!choices.contains(distractor)) {
          choices.add(distractor);
        }
      }
      choices.shuffle();
    }

    return MathProblem(
      term: term,
      solution: solution,
      choices: choices,
      inputType: difficulty.inputType,
    );
  }
}
