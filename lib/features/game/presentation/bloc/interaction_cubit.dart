import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_pet/features/game/presentation/bloc/interaction_state.dart';

class InteractionCubit extends Cubit<InteractionState> {
  InteractionCubit() : super(const InteractionState());

  void selectTool(GameTool tool) {
    if (state.selectedTool == tool) {
      // Toggle off if same tool clicked
      emit(state.copyWith(selectedTool: GameTool.none));
    } else {
      emit(state.copyWith(selectedTool: tool));
    }
  }

  void clearTool() {
    emit(state.copyWith(selectedTool: GameTool.none));
  }
}
