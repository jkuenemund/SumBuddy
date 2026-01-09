import 'package:equatable/equatable.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';

/// Defines a piece of furniture that can be unlocked and displayed in the room.
class FurnitureItem extends Equatable {
  final String id;
  final String assetPath;
  final double relativeX; // 0.0 to 1.0 (percentage of room width)
  final double relativeY; // 0.0 to 1.0 (percentage of room height)
  final double scale;
  final MathOperation? unlockPillar;
  final int unlockLevel; // 1, 2, 3...
  final bool isMasteryItem; // Mastery items unlock after max level is finished

  const FurnitureItem({
    required this.id,
    required this.assetPath,
    required this.relativeX,
    required this.relativeY,
    this.scale = 1.0,
    this.unlockPillar,
    required this.unlockLevel,
    this.isMasteryItem = false,
  });

  @override
  List<Object?> get props => [
    id,
    assetPath,
    relativeX,
    relativeY,
    scale,
    unlockPillar,
    unlockLevel,
    isMasteryItem,
  ];
}
