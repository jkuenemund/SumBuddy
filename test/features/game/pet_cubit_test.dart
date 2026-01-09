import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('PetCubit', () {
    test('initial state is correct', () {
      expect(PetCubit().state, const PetState());
    });

    test('feed increases hunger and happiness', () {
      final cubit = PetCubit()..feed();
      expect(cubit.state.hunger, 60); // 50 + 10
      expect(cubit.state.happiness, 55); // 50 + 5
      expect(cubit.state.action, PetAction.eating);
    });

    test('toJson/fromJson works', () {
      final cubit = PetCubit();
      final json = cubit.toJson(
        const PetState(hunger: 20, happiness: 10, action: PetAction.sad),
      );

      expect(json, {
        'hunger': 20,
        'happiness': 10,
        'action': 2, // sad
      });

      final state = cubit.fromJson(json!);
      expect(
        state,
        const PetState(hunger: 20, happiness: 10, action: PetAction.sad),
      );
    });
  });
}
