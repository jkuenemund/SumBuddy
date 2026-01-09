import 'package:flutter_test/flutter_test.dart';
import 'package:sum_buddy/features/math/domain/config/math_levels_config.dart';
import 'package:sum_buddy/features/math/domain/logic/math_generator.dart';

void main() {
  group('MathGenerator', () {
    test('generate creates valid addition problems', () {
      final level = MathLevelsConfig.levels.first; // Level 1 Addition
      for (var i = 0; i < 100; i++) {
        final problem = MathGenerator.generate(level);

        expect(problem.term, contains('+'));
        expect(problem.solution, greaterThan(0));
        expect(problem.choices.length, 3);
        expect(problem.choices.contains(problem.solution), true);
      }
    });

    test('generate creates valid subtraction problems', () {
      final level = MathLevelsConfig.levels.firstWhere(
        (l) => l.id.contains('sub'),
      );
      for (var i = 0; i < 100; i++) {
        final problem = MathGenerator.generate(level);

        expect(problem.term, contains('-'));
        expect(problem.solution, greaterThanOrEqualTo(0));
        expect(problem.choices.length, 3);
        expect(problem.choices.contains(problem.solution), true);
      }
    });

    test('generate creates valid multiplication problems', () {
      final level = MathLevelsConfig.levels.firstWhere(
        (l) => l.id.contains('mul'),
      );
      for (var i = 0; i < 100; i++) {
        final problem = MathGenerator.generate(level);

        expect(problem.term, contains('×'));
        expect(problem.choices.length, 3);
        expect(problem.choices.contains(problem.solution), true);
      }
    });

    test('generate creates valid division problems', () {
      final level = MathLevelsConfig.levels.firstWhere(
        (l) => l.id.contains('div'),
      );
      for (var i = 0; i < 100; i++) {
        final problem = MathGenerator.generate(level);

        expect(problem.term, contains('÷'));
        // Check integer result
        final parts = problem.term.split(' ÷ ');
        final a = int.parse(parts[0]);
        final b = int.parse(parts[1]);
        expect(a % b, 0);
        expect(a ~/ b, problem.solution);

        expect(problem.choices.length, 3);
        expect(problem.choices.contains(problem.solution), true);
      }
    });
  });
}
