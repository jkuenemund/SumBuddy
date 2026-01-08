import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';
import 'package:sum_buddy/features/game/presentation/widgets/sum_buddy_game_widget.dart';
import 'package:sum_buddy/features/game/presentation/widgets/pet_action_bar.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:sum_buddy/features/settings/presentation/bloc/settings_state.dart';
import 'package:sum_buddy/features/settings/presentation/dialogs/settings_dialog.dart';

/// The main page for the Game feature.
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PetCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => InteractionCubit()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            // Layer 1: The Game (Flame)
            const Positioned.fill(
              child: SumBuddyGameWidget(),
            ),

            // Layer 2: Top Bar (Settings)
            Positioned(
              top: 50,
              right: 20,
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.settings, size: 32),
                    onPressed: () => SettingsDialog.show(context),
                  );
                },
              ),
            ),

            // Layer 3: Debug Info (Conditional)
            Positioned(
              top: 50,
              left: 20,
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  if (!settingsState.debugMode) return const SizedBox.shrink();

                  return BlocBuilder<PetCubit, PetState>(
                    builder: (context, petState) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Hunger: ${petState.hunger} | '
                          'Happiness: ${petState.happiness}\n'
                          'Action: ${petState.action.name}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Layer 4: Action Bar (Bottom)
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: PetActionBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
