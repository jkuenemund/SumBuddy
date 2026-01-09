import 'package:sum_buddy/core/assets/asset_registry.dart';
import 'package:sum_buddy/features/game/domain/entities/furniture_item.dart';
import 'package:sum_buddy/features/math/domain/entities/math_operation.dart';

/// Central registry for all unlockable furniture items.
class FurnitureRegistry {
  static final List<FurnitureItem> items = [
    // --- ADDITION ---
    FurnitureItem(
      id: 'fur_rug',
      assetPath: AssetRegistry.room.rug,
      relativeX: 0.5,
      relativeY: 0.8,
      scale: 0.2,
      unlockPillar: MathOperation.addition,
      unlockLevel: 1,
    ),
    FurnitureItem(
      id: 'fur_sofa',
      assetPath: AssetRegistry.room.sofa,
      relativeX: 0.7,
      relativeY: 0.65,
      scale: 0.3,
      unlockPillar: MathOperation.addition,
      unlockLevel: 2,
    ),
    FurnitureItem(
      id: 'fur_petbed',
      assetPath: AssetRegistry.room.petBed,
      relativeX: 0.3,
      relativeY: 0.75,
      scale: 0.25,
      unlockPillar: MathOperation.addition,
      unlockLevel: 3,
    ),

    // --- SUBTRACTION ---
    FurnitureItem(
      id: 'fur_window',
      assetPath: 'assets/images/furniture/fur_window.png',
      relativeX: 0.2,
      relativeY: 0.3,
      unlockPillar: MathOperation.subtraction,
      unlockLevel: 1,
    ),
    FurnitureItem(
      id: 'fur_curtains',
      assetPath: 'assets/images/furniture/fur_curtains.png',
      relativeX: 0.2,
      relativeY: 0.3, // Same as window
      unlockPillar: MathOperation.subtraction,
      unlockLevel: 2,
    ),
    FurnitureItem(
      id: 'fur_plant',
      assetPath: 'assets/images/furniture/fur_plant.png',
      relativeX: 0.85,
      relativeY: 0.65,
      unlockPillar: MathOperation.subtraction,
      unlockLevel: 3,
    ),

    // --- MULTIPLICATION ---
    FurnitureItem(
      id: 'fur_shelf',
      assetPath: 'assets/images/furniture/fur_shelf.png',
      relativeX: 0.8,
      relativeY: 0.4,
      unlockPillar: MathOperation.multiplication,
      unlockLevel: 1,
    ),
    FurnitureItem(
      id: 'fur_lamp',
      assetPath: 'assets/images/furniture/fur_lamp.png',
      relativeX: 0.8,
      relativeY: 0.35, // On the shelf
      unlockPillar: MathOperation.multiplication,
      unlockLevel: 2,
    ),
    FurnitureItem(
      id: 'fur_trophy',
      assetPath: 'assets/images/furniture/fur_trophy.png',
      relativeX: 0.85,
      relativeY: 0.35,
      unlockPillar: MathOperation.multiplication,
      unlockLevel: 3,
      isMasteryItem: true,
    ),

    // --- DIVISION ---
    FurnitureItem(
      id: 'fur_clock',
      assetPath: 'assets/images/furniture/fur_clock.png',
      relativeX: 0.5,
      relativeY: 0.2,
      unlockPillar: MathOperation.division,
      unlockLevel: 1,
    ),
    FurnitureItem(
      id: 'fur_pc',
      assetPath: 'assets/images/furniture/fur_pc.png',
      relativeX: 0.15,
      relativeY: 0.6,
      unlockPillar: MathOperation.division,
      unlockLevel: 2,
    ),
    FurnitureItem(
      id: 'fur_arcade',
      assetPath: 'assets/images/furniture/fur_arcade.png',
      relativeX: 0.4,
      relativeY: 0.4,
      unlockPillar: MathOperation.division,
      unlockLevel: 3,
      isMasteryItem: true,
    ),
  ];
}
