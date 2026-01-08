import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_pet/features/game/presentation/bloc/pet_state.dart';

/// Manages the state of the Pet (Hunger, Happiness, Actions).
class PetCubit extends HydratedCubit<PetState> {
  PetCubit() : super(const PetState()) {
    // Start decay timer
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => _tick());
  }

  Timer? _ticker;

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }

  void _tick() {
    if (isClosed) return;

    // Decay hunger
    final newHunger = (state.hunger - 5).clamp(0, 100);

    // Check for Sadness (Hunger < 30)
    // Only switch to sad if currently idle (don't interrupt eating)
    var newAction = state.action;
    if (newHunger < 30 && state.action == PetAction.idle) {
      newAction = PetAction.sad;
    } else if (newHunger >= 30 && state.action == PetAction.sad) {
      newAction = PetAction.idle;
    }

    emit(
      state.copyWith(
        hunger: newHunger,
        action: newAction,
      ),
    );
  }

  /// Feeds the pet, increasing hunger (fullness) and happiness.
  void feed() {
    final newHunger = (state.hunger + 10).clamp(0, 100);
    final newHappiness = (state.happiness + 5).clamp(0, 100);

    emit(
      state.copyWith(
        hunger: newHunger,
        happiness: newHappiness,
        action: PetAction.eating,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) {
        // Return to Sad if still hungry, else Idle
        final action = newHunger < 30 ? PetAction.sad : PetAction.idle;
        emit(state.copyWith(action: action));
      }
    });
  }

  @override
  PetState? fromJson(Map<String, dynamic> json) => PetState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PetState state) => state.toJson();
}
