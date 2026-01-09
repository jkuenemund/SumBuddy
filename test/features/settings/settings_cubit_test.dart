import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_state.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('SettingsCubit', () {
    test('initial state is correct (debugMode: false)', () {
      expect(SettingsCubit().state.debugMode, false);
    });

    test('toggleDebugMode switches state', () {
      final cubit = SettingsCubit()..toggleDebugMode();
      expect(cubit.state.debugMode, true);
      cubit.toggleDebugMode();
      expect(cubit.state.debugMode, false);
    });

    test('toJson/fromJson works', () {
      final cubit = SettingsCubit();
      final json = cubit.toJson(const SettingsState(debugMode: true));
      expect(json, {'debugMode': true});

      final state = cubit.fromJson(json!);
      expect(state!.debugMode, true);
    });
  });
}
