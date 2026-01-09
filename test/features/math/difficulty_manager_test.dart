import 'package:flutter_test/flutter_test.dart';
import 'package:sum_buddy/features/math/domain/config/math_levels_config.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';
import 'package:sum_buddy/features/math/domain/logic/difficulty_manager.dart';

void main() {
  group('DifficultyManager', () {
    test('selectDifficulty picks the first level initially', () {
      final level = DifficultyManager.selectDifficulty(
        enabledOperations: {MathOperation.addition: true},
        proficiencyPoints: {},
        frustrationCount: 0,
      );

      expect(level.operation, MathOperation.addition);
      expect(level.id, MathLevelsConfig.levels.first.id);
    });

    test('selectDifficulty steps back on high frustration', () {
      // Simulate being at level 2
      final level1 = MathLevelsConfig.levels.firstWhere(
        (l) => l.operation == MathOperation.addition,
      );

      final selected = DifficultyManager.selectDifficulty(
        enabledOperations: {MathOperation.addition: true},
        proficiencyPoints: {
          level1.id: level1.pointsToNextLevel,
        }, // Level 1 mastered
        frustrationCount: MathLevelsConfig.antiFrustErrorStreak,
      );

      // Should step back to level 1 even if level 1 is mastered
      expect(selected.id, level1.id);
    });

    test('selectDifficulty introduces next level during soft transition', () {
      final level1 = MathLevelsConfig.levels.firstWhere(
        (l) => l.operation == MathOperation.addition,
      );

      // Seed with high progress (80%)
      final points =
          (level1.pointsToNextLevel * MathLevelsConfig.softTransitionThreshold)
              .ceil();

      var nextLevelCount = 0;
      for (int i = 0; i < 1000; i++) {
        final selected = DifficultyManager.selectDifficulty(
          enabledOperations: {MathOperation.addition: true},
          proficiencyPoints: {level1.id: points},
          frustrationCount: 0,
        );
        if (selected.id != level1.id &&
            selected.operation == MathOperation.addition) {
          nextLevelCount++;
        }
      }

      // Should have ~10% chance for next level
      expect(nextLevelCount, greaterThan(20)); // Loose bounds for randomness
    });
  });
}
