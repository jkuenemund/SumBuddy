import 'package:equatable/equatable.dart';

enum GameTool {
  none,
  feed,
  play, // Placeholder for future
}

class InteractionState extends Equatable {
  const InteractionState({
    this.selectedTool = GameTool.none,
  });

  final GameTool selectedTool;

  InteractionState copyWith({
    GameTool? selectedTool,
  }) {
    return InteractionState(
      selectedTool: selectedTool ?? this.selectedTool,
    );
  }

  @override
  List<Object> get props => [selectedTool];
}
