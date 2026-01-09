import 'package:sum_buddy/features/math/domain/entities/math_difficulty.dart';
import 'package:sum_buddy/features/math/domain/entities/math_input_type.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';

/// Centralized configuration for math levels and progression.
class MathLevelsConfig {
  /// Global settings for the math engine.
  static const int defaultStreakTarget = 3;
  static const double softTransitionThreshold =
      0.8; // Start showing next level at 80% progress
  static const int antiFrustErrorStreak = 3; // Step back after 3 errors

  /// Weighting for problem selection.
  static const double weightCurrentLevel = 0.7;
  static const double weightPreviousLevel = 0.25;
  static const double weightEasyLevel = 0.05;

  /// All predefined levels across all operations.
  static const List<MathDifficulty> levels = [
    // --- ADDITION ---
    MathDifficulty(
      id: 'add_1_10',
      label: 'Addition bis 20',
      operation: MathOperation.addition,
      minOperand: 1,
      maxOperand: 10,
      pointsToNextLevel: 5,
      streakTarget: 3,
      inputType: MathInputType.multipleChoice,
    ),
    MathDifficulty(
      id: 'add_1_20',
      label: 'Addition bis 40',
      operation: MathOperation.addition,
      minOperand: 1,
      maxOperand: 20,
      pointsToNextLevel: 10,
      streakTarget: 3,
      inputType: MathInputType.multipleChoice,
    ),
    MathDifficulty(
      id: 'add_1_50',
      label: 'Addition bis 100',
      operation: MathOperation.addition,
      minOperand: 1,
      maxOperand: 50,
      pointsToNextLevel: 15,
      streakTarget: 5,
      inputType: MathInputType.numericPad,
    ),

    // --- SUBTRACTION ---
    MathDifficulty(
      id: 'sub_1_10',
      label: 'Subtraktion bis 10',
      operation: MathOperation.subtraction,
      minOperand: 1,
      maxOperand: 10,
      pointsToNextLevel: 5,
      streakTarget: 3,
      inputType: MathInputType.multipleChoice,
    ),
    MathDifficulty(
      id: 'sub_1_20',
      label: 'Subtraktion bis 20',
      operation: MathOperation.subtraction,
      minOperand: 1,
      maxOperand: 20,
      pointsToNextLevel: 10,
      streakTarget: 3,
      inputType: MathInputType.multipleChoice,
    ),
    MathDifficulty(
      id: 'sub_neg',
      label: 'Negative Subtraktion',
      operation: MathOperation.subtraction,
      minOperand: 1,
      maxOperand: 20,
      pointsToNextLevel: 15,
      streakTarget: 5,
      ensurePositiveResult: false,
      inputType: MathInputType.numericPad,
    ),

    // --- MULTIPLICATION ---
    MathDifficulty(
      id: 'mul_1_5',
      label: 'Multiplikation bis 5',
      operation: MathOperation.multiplication,
      minOperand: 1,
      maxOperand: 5,
      pointsToNextLevel: 8,
      streakTarget: 3,
      inputType: MathInputType.multipleChoice,
    ),
    MathDifficulty(
      id: 'mul_1_10',
      label: 'Multiplikation bis 10',
      operation: MathOperation.multiplication,
      minOperand: 1,
      maxOperand: 10,
      pointsToNextLevel: 15,
      streakTarget: 4,
      inputType: MathInputType.numericPad,
    ),

    // --- DIVISION ---
    MathDifficulty(
      id: 'div_1_5',
      label: 'Division bis 5',
      operation: MathOperation.division,
      minOperand: 1,
      maxOperand: 5,
      pointsToNextLevel: 8,
      streakTarget: 3,
      inputType: MathInputType.multipleChoice,
    ),
    MathDifficulty(
      id: 'div_1_10',
      label: 'Division bis 10',
      operation: MathOperation.division,
      minOperand: 1,
      maxOperand: 10,
      pointsToNextLevel: 15,
      streakTarget: 4,
      inputType: MathInputType.numericPad,
    ),
  ];
}
