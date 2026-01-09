import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_state.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';
import 'package:sum_buddy/features/math/presentation/dialogs/math_dialog.dart';

/// Handles tap interactions and feeding logic for the Pet.
mixin PetInteractions
    on
        SpriteAnimationGroupComponent<PetAction>,
        HasGameReference<SumBuddyGame> {
  void handleTapUp(TapUpEvent event, {required void Function() onInteraction}) {
    final selectedTool = game.interactionCubit.state.selectedTool;

    if (selectedTool == GameTool.feed) {
      if (current == PetAction.idle || current == PetAction.sad) {
        unawaited(_handleFeeding());
      }
    } else if (selectedTool == GameTool.play) {
      // Placeholder for future tool
    }
    onInteraction();
  }

  Future<void> _handleFeeding() async {
    final context = game.buildContext;
    if (context == null) return;

    final difficulty = await MathDialog.show(context);

    if (difficulty != null) {
      game.petCubit.onMathSolved(difficulty);
      game.petCubit.feed();
    } else {
      // NOTE: We currently can't distinguish between cancel and error here
      // unless we change MathDialog return type further.
      // For now, failure to solve is handled inside MathDialog pop.
    }
  }
}
