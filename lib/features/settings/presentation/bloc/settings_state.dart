import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.debugMode = false,
  });

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      debugMode: json['debugMode'] as bool? ?? false,
    );
  }

  final bool debugMode;

  SettingsState copyWith({
    bool? debugMode,
  }) {
    return SettingsState(
      debugMode: debugMode ?? this.debugMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debugMode': debugMode,
    };
  }

  @override
  List<Object> get props => [debugMode];
}
