import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:sum_buddy/core/assets/asset_registry.dart';
import 'package:sum_buddy/features/game/game/components/pet/pet_animations.dart';
import 'package:sum_buddy/features/game/game/components/pet/pet_interactions.dart';
import 'package:sum_buddy/features/game/game/components/pet/pet_movement.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';

/// The visual representation of the Pet.
///
/// Refactored to use mixins for specialized logic:
/// - [PetAnimations] for blinking and waving.
/// - [PetMovement] for random walking.
/// - [PetInteractions] for tap and feeding.
class PetComponent extends SpriteAnimationGroupComponent<PetAction>
    with
        HasGameReference<SumBuddyGame>,
        FlameBlocListenable<PetCubit, PetState>,
        TapCallbacks,
        PetAnimations,
        PetMovement,
        PetInteractions {
  PetComponent({
    this.mouthOffset,
  }) : super(
         size: Vector2.all(100),
         anchor: Anchor.center,
       );

  /// Offset from the top-left of the pet to the mouth.
  final Vector2? mouthOffset;

  @override
  Future<void> onLoad() async {
    // Load Animations
    final idleSheet = await game.images.load(AssetRegistry.images.petIdle);
    final eatingSheet = await game.images.load(AssetRegistry.images.petEating);
    final sadSheet = await game.images.load(AssetRegistry.images.petSad);
    final blinkSheet = await game.images.load(AssetRegistry.images.petBlink);
    final waveSheet = await game.images.load(AssetRegistry.images.petWave);

    animations = {
      PetAction.idle: SpriteAnimation.fromFrameData(
        idleSheet,
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(1024, 1024),
        ),
      ),
      PetAction.eating: SpriteAnimation.fromFrameData(
        eatingSheet,
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(1024, 1024),
        ),
      ),
      PetAction.sad: SpriteAnimation.fromFrameData(
        sadSheet,
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(1024, 1024),
        ),
      ),
      PetAction.blinking: SpriteAnimation.fromFrameData(
        blinkSheet,
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2(1024, 1024),
          loop: false,
        ),
      ),
      PetAction.waving: SpriteAnimation.fromFrameData(
        waveSheet,
        SpriteAnimationData(
          [0, 1, 2, 1, 2, 1, 0].map((index) {
            return SpriteAnimationFrameData(
              srcPosition: Vector2(index * 1024.0, 0),
              srcSize: Vector2(1024, 1024),
              stepTime: index == 0 ? 0.2 : 0.1,
            );
          }).toList(),
          loop: false,
        ),
      ),
    };

    current = game.petCubit.state.action;
  }

  @override
  void onMount() {
    super.onMount();
    position = Vector2(game.size.x / 2, game.size.y - (size.y / 2) - 40);
    _updateScaleFromHunger(game.petCubit.state.hunger);
    resetWalkTimer();
  }

  @override
  void onNewState(PetState state) {
    _updateScaleFromHunger(state.hunger);

    final isVisualOnly =
        current == PetAction.blinking || current == PetAction.waving;

    if (state.action != current) {
      if (!isVisualOnly ||
          (state.action != PetAction.idle && state.action != PetAction.sad)) {
        current = state.action;

        if (state.action == PetAction.eating) {
          stopWalking();
        } else if (!isWalking) {
          resetWalkTimer();
        }
        resetWaveTimer();
      }
    }
    super.onNewState(state);
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateAnimations(dt, isWalking: isWalking);
    updateMovement(dt);
  }

  void _updateScaleFromHunger(int hunger) {
    final baseGrowthScale = 0.6 + (hunger / 100) * 0.8;
    final sign = scale.x.sign;
    scale = Vector2(sign * baseGrowthScale, baseGrowthScale);
  }

  @override
  void onTapUp(TapUpEvent event) {
    handleTapUp(event, onInteraction: resetWaveTimer);
    super.onTapUp(event);
  }

  /// Plays a chewing animation (pulsing scale).
  void playChewAnimation() {
    final currentScale = scale.y;
    final pulseScale = currentScale * 1.1;
    final currentSign = scale.x.sign;

    unawaited(
      Future.value(
        add(
          ScaleEffect.to(
            Vector2(currentSign * pulseScale, pulseScale),
            EffectController(
              duration: 0.1,
              reverseDuration: 0.1,
              repeatCount: 5,
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the global position where food should fly to.
  Vector2 get mouthPosition {
    final offset = mouthOffset ?? Vector2(0, 10);
    return position + offset;
  }

  /// Returns the local mouth position for child components.
  Vector2 get localMouthPosition {
    final offset = mouthOffset ?? Vector2(0, 10);
    return (size / 2) + offset;
  }
}
