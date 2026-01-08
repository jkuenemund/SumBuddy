import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:sum_buddy/features/game/game/components/food_component.dart';
import 'package:sum_buddy/features/game/game/components/pet_component.dart';
import 'package:sum_buddy/features/game/game/components/room_component.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_state.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';

/// The main Game class for Math Pet.
///
/// This class is responsible for the Game Loop and managing
/// all top-level components.
class SumBuddyGame extends FlameGame {
  SumBuddyGame({
    required this.petCubit,
    required this.interactionCubit,
  }) : super(children: []);

  final PetCubit petCubit;
  final InteractionCubit interactionCubit;
  late final PetComponent pet;

  @override
  Future<void> onLoad() async {
    // 1. Add Background
    await add(RoomComponent());

    // 2. Setup Pet
    pet = PetComponent();

    // 3. Add Pet with Bloc Providers
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<PetCubit, PetState>.value(value: petCubit),
          FlameBlocProvider<InteractionCubit, InteractionState>.value(
            value: interactionCubit,
          ),
        ],
        children: [pet],
      ),
    );

    // 4. Listen to pet state to spawn food
    petCubit.stream.listen((state) {
      if (state.action == PetAction.eating) {
        unawaited(_spawnFood());
      }
    });
  }

  Future<void> _spawnFood() async {
    final food = FoodComponent(
      foodType: FoodType.cookie,
      targetPosition: pet.mouthPosition,
      position: Vector2(size.x / 2, size.y + 50), // Spawn from bottom
      onArrival: () {
        // When food arrives at pet's mouth:
        // 1. Remove from game
        // 2. Add as child of Pet for relative movement
        // 3. Start animations
        final cookie = FoodComponent(
          foodType: FoodType.cookie,
          position: pet.localMouthPosition,
          isFlying: false,
        );
        final _ = pet.add(cookie);
        cookie.startEating();
        pet.playChewAnimation();
      },
    );
    await add(food);
  }
}
