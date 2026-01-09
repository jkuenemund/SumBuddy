import 'package:equatable/equatable.dart';
import 'package:sum_buddy/features/math/domain/entities/math_input_type.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';

/// Represents a level of math difficulty.
class MathDifficulty extends Equatable {
  const MathDifficulty({
    required this.id,
    required this.label,
    required this.operation,
    required this.minOperand,
    required this.maxOperand,
    this.pointsToNextLevel = 5,
    this.streakTarget = 3,
    this.inputType = MathInputType.multipleChoice,
    this.ensurePositiveResult = true,
  });

  /// Unique identifier for the level.
  final String id;

  /// Display label for the level.
  final String label;

  /// The math operation for this level.
  final MathOperation operation;

  /// Minimum value for operands.
  final int minOperand;

  /// Maximum value for operands.
  final int maxOperand;

  /// How many "Proficiency Points" are needed to unlock the next level.
  final int pointsToNextLevel;

  /// How many correct answers in a row yield 1 Proficiency Point.
  final int streakTarget;

  /// How the answer is entered.
  final MathInputType inputType;

  /// Whether to ensure the result is positive (relevant for subtraction).
  final bool ensurePositiveResult;

  @override
  List<Object?> get props => [
    id,
    label,
    operation,
    minOperand,
    maxOperand,
    pointsToNextLevel,
    streakTarget,
    inputType,
    ensurePositiveResult,
  ];
}
