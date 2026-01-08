import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';

/// A Flutter Widget that creates and displays the [SumBuddyGame].
///
/// This widget acts as the 'View' for the game feature.
/// It is responsible for instantiating the [GameWidget].
class SumBuddyGameWidget extends StatelessWidget {
  const SumBuddyGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: SumBuddyGame(
        petCubit: context.read<PetCubit>(),
        interactionCubit: context.read<InteractionCubit>(),
      ),
    );
  }
}
