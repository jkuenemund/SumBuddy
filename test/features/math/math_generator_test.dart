import 'package:flutter_test/flutter_test.dart';
import 'package:math_pet/features/math/domain/logic/math_generator.dart';

void main() {
  group('MathGenerator', () {
    test('generateAdditionProblem creates valid problems', () {
      final generator = MathGenerator();
      for (var i = 0; i < 100; i++) {
        final problem = generator.generateAdditionProblem();

        // 1. Check problem structure
        expect(problem.term, contains('+'));
        expect(problem.solution, lessThanOrEqualTo(20));
        expect(problem.solution, greaterThan(0));

        // 2. Check Choices
        expect(problem.choices.length, 3);
        expect(problem.choices.contains(problem.solution), true);

        // 3. Check Uniqueness
        final unique = problem.choices.toSet();
        expect(
          unique.length,
          3,
          reason: 'Choices must be unique: ${problem.choices}',
        );
      }
    });
  });
}
