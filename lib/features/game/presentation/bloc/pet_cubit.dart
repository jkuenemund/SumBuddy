import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sum_buddy/features/math/domain/entities/math_difficulty.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';

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

  /// Called when a math problem is solved correctly.
  void onMathSolved(MathDifficulty level) {
    final nextStreaks = Map<String, int>.from(state.activeStreaks);
    final nextProficiency = Map<String, int>.from(state.proficiencyPoints);

    final currentStreak = (nextStreaks[level.id] ?? 0) + 1;

    if (currentStreak >= level.streakTarget) {
      nextStreaks[level.id] = 0;
      nextProficiency[level.id] = (nextProficiency[level.id] ?? 0) + 1;
    } else {
      nextStreaks[level.id] = currentStreak;
    }

    emit(
      state.copyWith(
        totalGlobalPoints: state.totalGlobalPoints + 10,
        activeStreaks: nextStreaks,
        proficiencyPoints: nextProficiency,
        frustrationCount: 0, // Reset frustration on success
      ),
    );
  }

  /// Called when a math problem is answered incorrectly.
  void onMathError(MathDifficulty level) {
    final nextStreaks = Map<String, int>.from(state.activeStreaks);
    nextStreaks[level.id] = 0; // Reset streak on error

    emit(
      state.copyWith(
        activeStreaks: nextStreaks,
        frustrationCount: state.frustrationCount + 1,
      ),
    );
  }

  /// DEBUG: Manually set proficiency points for a level.
  void setProficiencyPoints(String levelId, int points) {
    final nextProficiency = Map<String, int>.from(state.proficiencyPoints);
    nextProficiency[levelId] = points;
    emit(state.copyWith(proficiencyPoints: nextProficiency));
  }

  /// DEBUG: Reset all progress stats.
  void resetProgress() {
    emit(
      state.copyWith(
        totalGlobalPoints: 0,
        proficiencyPoints: {},
        activeStreaks: {},
        frustrationCount: 0,
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
