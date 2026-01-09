import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';

/// Handles movement logic (random walking) for the Pet.
mixin PetMovement
    on
        SpriteAnimationGroupComponent<PetAction>,
        HasGameReference<SumBuddyGame> {
  final Random _random = Random();
  double _timeUntilNextWalk = 5;
  bool isWalking = false;

  void updateMovement(double dt) {
    final isWalkable = current == PetAction.idle || current == PetAction.sad;
    if (isWalkable && !isWalking) {
      _timeUntilNextWalk -= dt;
      if (_timeUntilNextWalk <= 0) {
        startRandomWalk();
      }
    }
  }

  void startRandomWalk() {
    if (game.size.x <= size.x) return;

    isWalking = true;

    final margin = size.x / 2;
    final availableWidth = (game.size.x - size.x).clamp(0, double.infinity);

    final targetX = _random.nextDouble() * availableWidth + margin;
    final baseLineY = game.size.y - (size.y / 2);
    final targetY = baseLineY - 40 - (_random.nextDouble() * 40);
    final target = Vector2(targetX, targetY);

    if (target.x < position.x && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (target.x > position.x && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    unawaited(
      Future.value(
        add(
          MoveToEffect(
            target,
            EffectController(
              speed: 80,
              curve: Curves.easeInOut,
            ),
            onComplete: () {
              isWalking = false;
              resetWalkTimer();
            },
          ),
        ),
      ),
    );
  }

  void stopWalking() {
    isWalking = false;
    children.whereType<MoveToEffect>().forEach((e) => e.removeFromParent());
  }

  void resetWalkTimer() {
    _timeUntilNextWalk =
        5.0 + (DateTime.now().millisecondsSinceEpoch % 5000) / 1000.0;
  }
}
