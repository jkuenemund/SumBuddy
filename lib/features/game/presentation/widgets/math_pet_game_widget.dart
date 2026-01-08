import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_pet/features/game/game/math_pet_game.dart';
import 'package:math_pet/features/game/presentation/bloc/interaction_cubit.dart';
import 'package:math_pet/features/game/presentation/bloc/pet_cubit.dart';

/// A Flutter Widget that creates and displays the [MathPetGame].
///
/// This widget acts as the 'View' for the game feature.
/// It is responsible for instantiating the [GameWidget].
class MathPetGameWidget extends StatelessWidget {
  const MathPetGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MathPetGame(
        petCubit: context.read<PetCubit>(),
        interactionCubit: context.read<InteractionCubit>(),
      ),
    );
  }
}
