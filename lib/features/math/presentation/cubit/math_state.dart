import 'package:equatable/equatable.dart';
import 'package:math_pet/features/math/domain/entities/math_problem.dart';

enum MathStatus { initial, problemLoaded, success, failure }

class MathState extends Equatable {
  const MathState({
    this.status = MathStatus.initial,
    this.problem,
  });

  final MathStatus status;
  final MathProblem? problem;

  MathState copyWith({
    MathStatus? status,
    MathProblem? problem,
  }) {
    return MathState(
      status: status ?? this.status,
      problem: problem ?? this.problem,
    );
  }

  @override
  List<Object?> get props => [status, problem];
}
