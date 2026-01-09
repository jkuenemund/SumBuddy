import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:sum_buddy/features/game/domain/entities/furniture_item.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';

/// A component representing a single piece of furniture in the room.
class FurnitureComponent extends SpriteComponent
    with HasGameReference<SumBuddyGame> {
  final FurnitureItem item;

  FurnitureComponent(this.item);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(item.assetPath);

    // Position is relative to the room (which is the full screen size)
    anchor = Anchor.center;
    position = Vector2(
      game.size.x * item.relativeX,
      game.size.y * item.relativeY,
    );

    // Add a small entrance animation
    opacity = 0;
    scale = Vector2.all(item.scale * 0.8);
    add(OpacityEffect.fadeIn(LinearEffectController(0.5)));
    add(ScaleEffect.to(Vector2.all(item.scale), LinearEffectController(0.5)));
  }
}
