import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleDebugMode() {
    emit(state.copyWith(debugMode: !state.debugMode));
  }

  void toggleMathOperation(MathOperation operation) {
    final newOperations = Set<MathOperation>.from(state.enabledOperations);
    if (newOperations.contains(operation)) {
      // Ensure at least one is enabled
      if (newOperations.length > 1) {
        newOperations.remove(operation);
      }
    } else {
      newOperations.add(operation);
    }
    emit(state.copyWith(enabledOperations: newOperations));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SettingsState state) => state.toJson();
}
