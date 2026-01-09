import 'package:equatable/equatable.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.debugMode = false,
    this.enabledOperations = const {
      MathOperation.addition,
      MathOperation.subtraction,
      MathOperation.multiplication,
      MathOperation.division,
    },
  });

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    final operationsJson = json['enabledOperations'] as List<dynamic>?;
    final enabledOperations = operationsJson != null
        ? operationsJson.map((e) => MathOperation.values[e as int]).toSet()
        : const {
            MathOperation.addition,
            MathOperation.subtraction,
            MathOperation.multiplication,
            MathOperation.division,
          };

    return SettingsState(
      debugMode: json['debugMode'] as bool? ?? false,
      enabledOperations: enabledOperations,
    );
  }

  final bool debugMode;
  final Set<MathOperation> enabledOperations;

  SettingsState copyWith({
    bool? debugMode,
    Set<MathOperation>? enabledOperations,
  }) {
    return SettingsState(
      debugMode: debugMode ?? this.debugMode,
      enabledOperations: enabledOperations ?? this.enabledOperations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debugMode': debugMode,
      'enabledOperations': enabledOperations.map((e) => e.index).toList(),
    };
  }

  @override
  List<Object> get props => [debugMode, enabledOperations];
}
