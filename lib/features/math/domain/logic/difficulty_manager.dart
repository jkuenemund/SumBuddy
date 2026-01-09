import 'dart:math';

import 'package:sum_buddy/features/math/domain/config/math_levels_config.dart';
import 'package:sum_buddy/features/math/domain/entities/math_difficulty.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';

/// Decision logic for selecting the next math challenge.
class DifficultyManager {
  static final _random = Random();

  /// Decides which difficulty level to use based on user progress and settings.
  static MathDifficulty selectDifficulty({
    required Map<MathOperation, bool> enabledOperations,
    required Map<String, int> proficiencyPoints,
    required int frustrationCount,
  }) {
    // 1. Filter enabled operations
    final activeOps = enabledOperations.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (activeOps.isEmpty) {
      return MathLevelsConfig.levels.first;
    }

    // 2. Determine current level for a randomly selected active operation
    final selectedOp = activeOps[_random.nextInt(activeOps.length)];
    final opLevels = MathLevelsConfig.levels
        .where((l) => l.operation == selectedOp)
        .toList();

    if (opLevels.isEmpty) return MathLevelsConfig.levels.first;

    // 3. Find current "Headed" level (the highest level with some points or the first)
    int currentLevelIndex = 0;
    for (int i = 0; i < opLevels.length; i++) {
      final points = proficiencyPoints[opLevels[i].id] ?? 0;
      if (points < opLevels[i].pointsToNextLevel) {
        currentLevelIndex = i;
        break;
      }
      currentLevelIndex = i; // Mastery reached
    }

    // 4. Check for Anti-Frust: Step back if frustration is high
    if (frustrationCount >= MathLevelsConfig.antiFrustErrorStreak &&
        currentLevelIndex > 0) {
      currentLevelIndex--;
    }

    final currentLevel = opLevels[currentLevelIndex];
    final nextLevel = (currentLevelIndex + 1 < opLevels.length)
        ? opLevels[currentLevelIndex + 1]
        : null;

    // 5. Apply Soft Transition weighting (only if not frustrated)
    final currentPoints = proficiencyPoints[currentLevel.id] ?? 0;
    final progress = currentPoints / currentLevel.pointsToNextLevel;

    final roll = _random.nextDouble();

    if (nextLevel != null &&
        progress >= MathLevelsConfig.softTransitionThreshold &&
        frustrationCount < MathLevelsConfig.antiFrustErrorStreak) {
      // Near mastery: 10% chance for preview of next level
      if (roll < 0.1) return nextLevel;
      if (roll < 0.1 + MathLevelsConfig.weightEasyLevel &&
          currentLevelIndex > 0) {
        return opLevels[0]; // Easy reinforcement
      }
      return currentLevel;
    }

    // Normal weighting: 70% current, 25% previous (if any), 5% very easy
    if (roll < MathLevelsConfig.weightCurrentLevel || currentLevelIndex == 0) {
      return currentLevel;
    } else if (roll <
        MathLevelsConfig.weightCurrentLevel +
            MathLevelsConfig.weightPreviousLevel) {
      return opLevels[max(0, currentLevelIndex - 1)];
    } else {
      return opLevels[0];
    }
  }
}
