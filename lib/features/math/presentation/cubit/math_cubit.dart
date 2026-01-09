import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_buddy/features/math/domain/entities/math_difficulty.dart';
import 'package:sum_buddy/features/math/domain/logic/math_generator.dart';
import 'package:sum_buddy/features/math/presentation/cubit/math_state.dart';

class MathCubit extends Cubit<MathState> {
  MathCubit() : super(const MathState());

  void generateProblem(MathDifficulty difficulty) {
    final problem = MathGenerator.generate(difficulty);
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
      emit(state.copyWith(status: MathStatus.failure));
    }
  }
}
