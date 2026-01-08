import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_pet/features/math/domain/logic/math_generator.dart';
import 'package:math_pet/features/math/presentation/cubit/math_state.dart';

class MathCubit extends Cubit<MathState> {
  MathCubit({MathGenerator? generator})
    : _generator = generator ?? MathGenerator(),
      super(const MathState());

  final MathGenerator _generator;

  void generateProblem() {
    final problem = _generator.generateAdditionProblem();
    emit(
      state.copyWith(
        status: MathStatus.problemLoaded,
        problem: problem,
      ),
    );
  }

  void checkAnswer(int answer) {
    if (state.problem == null) return;

    if (answer == state.problem!.solution) {
      emit(state.copyWith(status: MathStatus.success));
    } else {
      // For now, failure is final for this dialog instance.
      // In future, we might allow retries or shake animation.
      emit(state.copyWith(status: MathStatus.failure));
    }
  }
}
