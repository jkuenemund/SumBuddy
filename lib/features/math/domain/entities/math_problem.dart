import 'package:equatable/equatable.dart';
import 'package:sum_buddy/features/math/domain/entities/math_input_type.dart';

/// Represents a single math problem.
class MathProblem extends Equatable {
  const MathProblem({
    required this.term,
    required this.solution,
    required this.choices,
    required this.inputType,
  });

  /// The visual string of the problem (e.g., "3 + 4").
  final String term;

  /// The correct numeric solution.
  final int solution;

  /// List of potential answers for Multiple Choice.
  /// If empty, it implies Free Input mode.
  final List<int> choices;

  /// How the user enters the answer.
  final MathInputType inputType;

  @override
  List<Object> get props => [term, solution, choices, inputType];
}
