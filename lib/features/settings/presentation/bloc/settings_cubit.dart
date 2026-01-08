import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_pet/features/settings/presentation/bloc/settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleDebugMode() {
    emit(state.copyWith(debugMode: !state.debugMode));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SettingsState state) => state.toJson();
}
