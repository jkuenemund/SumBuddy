import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:sum_buddy/core/assets/asset_registry.dart';
import 'package:sum_buddy/features/game/domain/entities/furniture_item.dart';
import 'package:sum_buddy/features/game/domain/config/furniture_config.dart';
import 'package:sum_buddy/features/game/game/components/furniture_component.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';
import 'package:sum_buddy/features/math/domain/config/math_levels_config.dart';

/// The Room Background component.
/// Now dynamic: Displays a background and manages furniture based on progress.
class RoomComponent extends PositionComponent
    with
        HasGameReference<SumBuddyGame>,
        FlameBlocListenable<PetCubit, PetState> {
  late SpriteComponent _bgSprite;
  final Map<String, FurnitureComponent> _furnitureMap = {};

  @override
  Future<void> onLoad() async {
    size = game.size;

    _bgSprite = SpriteComponent()
      ..sprite = await game.loadSprite(AssetRegistry.room.background)
      ..size = size;
    add(_bgSprite);
  }

  @override
  void onMount() {
    super.onMount();
    // Process initial state immediately on mount using direct cubit reference
    // to avoid assertion errors before the listener is fully ready.
    _updateFurniture(game.petCubit.state);
  }

  @override
  void onNewState(PetState state) {
    _updateFurniture(state);
  }

  void _updateFurniture(PetState state) {
    for (final item in FurnitureRegistry.items) {
      final isUnlocked = _checkUnlock(item, state);
      final isCurrentlyInRoom = _furnitureMap.containsKey(item.id);

      if (isUnlocked && !isCurrentlyInRoom) {
        _addFurniture(item);
      } else if (!isUnlocked && isCurrentlyInRoom) {
        _removeFurniture(item.id);
      }
    }
  }

  bool _checkUnlock(FurnitureItem item, PetState state) {
    if (item.unlockPillar == null) return true;

    // Get all levels for this pillar
    final opLevels = MathLevelsConfig.levels
        .where((l) => l.operation == item.unlockPillar)
        .toList();

    // Find how many levels are mastered
    int masteredCount = 0;
    for (final level in opLevels) {
      final points = state.proficiencyPoints[level.id] ?? 0;
      if (points >= level.pointsToNextLevel) {
        masteredCount++;
      } else {
        break; // Stop at the first unmastered level
      }
    }

    // Logic: unlockLevel 1 means 1 level mastered.
    return masteredCount >= item.unlockLevel;
  }

  void _addFurniture(FurnitureItem item) {
    final component = FurnitureComponent(item);
    _furnitureMap[item.id] = component;
    add(component);
  }

  void _removeFurniture(String id) {
    final component = _furnitureMap.remove(id);
    if (component != null) {
      remove(component);
    }
  }
}
