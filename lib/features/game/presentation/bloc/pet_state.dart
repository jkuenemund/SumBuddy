import 'package:equatable/equatable.dart';

enum PetAction { idle, eating, sad, blinking }

class PetState extends Equatable {
  const PetState({
    this.hunger = 50,
    this.happiness = 50,
    this.action = PetAction.idle,
  });

  factory PetState.fromJson(Map<String, dynamic> json) {
    final hunger = json['hunger'] as int? ?? 50;
    final savedAction = PetAction.values[json['action'] as int? ?? 0];

    // Ensure state consistency on startup:
    // If hunger is low, pet should be sad.
    final action = (hunger < 30 && savedAction == PetAction.idle)
        ? PetAction.sad
        : savedAction;

    return PetState(
      hunger: hunger,
      happiness: json['happiness'] as int? ?? 50,
      action: action,
    );
  }

  /// Hunger level from 0 (starving) to 100 (full).
  final int hunger;

  /// Happiness level from 0 (sad) to 100 (happy).
  final int happiness;

  /// Current visual action of the pet.
  final PetAction action;

  PetState copyWith({
    int? hunger,
    int? happiness,
    PetAction? action,
  }) {
    return PetState(
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      action: action ?? this.action,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hunger': hunger,
      'happiness': happiness,
      'action': action.index,
    };
  }

  @override
  List<Object> get props => [hunger, happiness, action];
}
