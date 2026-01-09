import 'package:equatable/equatable.dart';

enum PetAction { idle, eating, sad, blinking, waving }

class PetState extends Equatable {
  const PetState({
    this.hunger = 50,
    this.happiness = 50,
    this.action = PetAction.idle,
    this.totalGlobalPoints = 0,
    this.proficiencyPoints = const {},
    this.activeStreaks = const {},
    this.frustrationCount = 0,
  });

  factory PetState.fromJson(Map<String, dynamic> json) {
    final hunger = json['hunger'] as int? ?? 50;
    final savedAction = PetAction.values[json['action'] as int? ?? 0];

    // Ensure state consistency on startup
    final action = (hunger < 30 && savedAction == PetAction.idle)
        ? PetAction.sad
        : savedAction;

    return PetState(
      hunger: hunger,
      happiness: json['happiness'] as int? ?? 50,
      action: action,
      totalGlobalPoints:
          json['totalGlobalPoints'] as int? ?? json['mathPoints'] as int? ?? 0,
      proficiencyPoints:
          (json['proficiencyPoints'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const {},
      activeStreaks:
          (json['activeStreaks'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const {},
      frustrationCount: json['frustrationCount'] as int? ?? 0,
    );
  }

  /// Hunger level from 0 (starving) to 100 (full).
  final int hunger;

  /// Happiness level from 0 (sad) to 100 (happy).
  final int happiness;

  /// Current visual action of the pet.
  final PetAction action;

  /// Total points earned by solving math problems.
  final int totalGlobalPoints;

  /// Earned points per level ID.
  final Map<String, int> proficiencyPoints;

  /// Current consecutive correct answers per level ID.
  final Map<String, int> activeStreaks;

  /// Tracks recent errors for anti-frust logic.
  final int frustrationCount;

  PetState copyWith({
    int? hunger,
    int? happiness,
    PetAction? action,
    int? totalGlobalPoints,
    Map<String, int>? proficiencyPoints,
    Map<String, int>? activeStreaks,
    int? frustrationCount,
  }) {
    return PetState(
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      action: action ?? this.action,
      totalGlobalPoints: totalGlobalPoints ?? this.totalGlobalPoints,
      proficiencyPoints: proficiencyPoints ?? this.proficiencyPoints,
      activeStreaks: activeStreaks ?? this.activeStreaks,
      frustrationCount: frustrationCount ?? this.frustrationCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hunger': hunger,
      'happiness': happiness,
      'action': action.index,
      'totalGlobalPoints': totalGlobalPoints,
      'proficiencyPoints': proficiencyPoints,
      'activeStreaks': activeStreaks,
      'frustrationCount': frustrationCount,
    };
  }

  @override
  List<Object> get props => [
    hunger,
    happiness,
    action,
    totalGlobalPoints,
    proficiencyPoints,
    activeStreaks,
    frustrationCount,
  ];
}
