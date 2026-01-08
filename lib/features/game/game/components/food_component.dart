import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:math_pet/core/assets/asset_registry.dart';
import 'package:math_pet/features/game/game/math_pet_game.dart';

enum FoodType { cookie, cake, apple }

class FoodComponent extends SpriteComponent with HasGameReference<MathPetGame> {
  FoodComponent({
    required Vector2 position,
    required this.foodType,
    this.targetPosition,
    this.onArrival,
    this.isFlying = true,
  }) : super(
         position: position,
         size: Vector2.all(50),
         anchor: Anchor.center,
       );

  final FoodType foodType;
  final Vector2? targetPosition;
  final VoidCallback? onArrival;
  final bool isFlying;

  @override
  Future<void> onLoad() async {
    final assetPath = _getAssetPath();
    sprite = await game.loadSprite(assetPath);

    if (isFlying && targetPosition != null) {
      // Animation: Fly towards the pet
      add(
        MoveToEffect(
          targetPosition!,
          EffectController(
            duration: 0.8,
            curve: Curves.easeOutCubic,
          ),
          onComplete: () {
            onArrival?.call();
            removeFromParent();
          },
        ),
      );

      // Animation: Small rotation while flying
      add(
        RotateEffect.by(
          0.2,
          EffectController(
            duration: 0.4,
            reverseDuration: 0.4,
            repeatCount: 1,
          ),
        ),
      );
    }
  }

  /// Starts the "getting eaten" animation.
  void startEating() {
    // Use a discarded variable to satisfy the discarded_futures lint
    // since add returns FutureOr<void>.
    final _ = add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(
          duration: 1,
          curve: Curves.easeInQuad,
        ),
        onComplete: removeFromParent,
      ),
    );
  }

  String _getAssetPath() {
    switch (foodType) {
      case FoodType.cookie:
        return AssetRegistry.images.foodCookie;
      case FoodType.cake:
        return AssetRegistry.images.foodCake;
      case FoodType.apple:
        return AssetRegistry.images.foodApple;
    }
  }
}
