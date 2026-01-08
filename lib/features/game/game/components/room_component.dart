import 'package:flame/components.dart';
import 'package:sum_buddy/core/assets/asset_registry.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';

/// The Room Background component.
/// Displays a static image of the room.
class RoomComponent extends SpriteComponent with HasGameReference<SumBuddyGame> {
  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(AssetRegistry.images.background);
    size = game.size; // Fill the screen
    position = Vector2.zero();
  }
}
