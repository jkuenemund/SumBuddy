import 'package:flame/components.dart';
import 'package:math_pet/core/assets/asset_registry.dart';
import 'package:math_pet/features/game/game/math_pet_game.dart';

/// The Room Background component.
/// Displays a static image of the room.
class RoomComponent extends SpriteComponent with HasGameReference<MathPetGame> {
  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(AssetRegistry.images.background);
    size = game.size; // Fill the screen
    position = Vector2.zero();
  }
}
