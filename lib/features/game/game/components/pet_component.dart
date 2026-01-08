import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:sum_buddy/core/assets/asset_registry.dart';
import 'package:sum_buddy/features/game/game/sum_buddy_game.dart';
import 'package:sum_buddy/features/game/presentation/bloc/interaction_state.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_cubit.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';
import 'package:sum_buddy/features/math/presentation/dialogs/math_dialog.dart';

/// The visual representation of the Pet.
///
/// Listens to [PetCubit] state changes to switch between animations
/// (Idle <-> Eating).
class PetComponent extends SpriteAnimationGroupComponent<PetAction>
    with
        HasGameReference<SumBuddyGame>,
        FlameBlocListenable<PetCubit, PetState>,
        TapCallbacks {
  PetComponent({
    this.mouthOffset,
  }) : super(
         size: Vector2.all(100),
         anchor: Anchor.center,
       );

  /// Offset from the top-left of the pet to the mouth.
  /// If null, a default center-ish offset is used.
  final Vector2? mouthOffset;

  @override
  Future<void> onLoad() async {
    // Load Animations

    // Load Blinking Animation
    // Sheet is 2 frames, 0.1s blink duration
    final blinkSheet = await game.images.load(AssetRegistry.images.petBlink);
    final blinkAnimation = SpriteAnimation.fromFrameData(
      blinkSheet,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.1,
        textureSize: Vector2(1024, 1024),
        loop: false,
      ),
    );

    _blinkAnimation = blinkAnimation;

    animations = {
      PetAction.idle: SpriteAnimation.fromFrameData(
        await game.images.load(AssetRegistry.images.petIdle),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(1024, 1024),
        ),
      ),
      PetAction.eating: SpriteAnimation.fromFrameData(
        await game.images.load(AssetRegistry.images.petEating),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(1024, 1024),
        ),
      ),
      PetAction.sad: SpriteAnimation.fromFrameData(
        await game.images.load(AssetRegistry.images.petSad),
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(1024, 1024),
        ),
      ),
      PetAction.blinking: _blinkAnimation,
    };

    // Initial state from Cubit
    current = game.petCubit.state.action;
  }

  late final SpriteAnimation _blinkAnimation;
  double _timeUntilBlink = 3;

  @override
  void onMount() {
    super.onMount();
    // Set initial position to bottom center
    position = Vector2(game.size.x / 2, game.size.y - (size.y / 2) - 40);
    _updateScaleFromHunger(game.petCubit.state.hunger);
    _resetWalkTimer();
  }

  @override
  void onNewState(PetState state) {
    // Update growth scale based on hunger
    _updateScaleFromHunger(state.hunger);

    // React to state changes from Cubit
    if (state.action != current) {
      current = state.action;

      // Stop walking if we start eating
      if (state.action == PetAction.eating) {
        _stopWalking();
      } else if (!_isWalking) {
        // Restart random walk timer if we are in a walkable state
        _resetWalkTimer();
      }
    }
    super.onNewState(state);
  }

  double _baseGrowthScale = 1;

  void _updateScaleFromHunger(int hunger) {
    // hunger 0 -> scale 0.6, hunger 100 -> scale 1.4
    _baseGrowthScale = 0.6 + (hunger / 100) * 0.8;

    // Apply while keeping current horizontal flip
    final sign = scale.x.sign;
    scale = Vector2(sign * _baseGrowthScale, _baseGrowthScale);
  }

  double _timeUntilNextWalk = 5;
  bool _isWalking = false;
  final _random = Random();

  @override
  void update(double dt) {
    super.update(dt);

    // Blinking logic (in idle or sad)
    final canBlink = current == PetAction.idle || current == PetAction.sad;
    if (canBlink) {
      _timeUntilBlink -= dt;
      if (_timeUntilBlink <= 0) {
        _blink();
      }
    }

    // Walk in idle or sad state
    final isWalkable = current == PetAction.idle || current == PetAction.sad;
    if (isWalkable && !_isWalking) {
      _timeUntilNextWalk -= dt;
      if (_timeUntilNextWalk <= 0) {
        _startRandomWalk();
      }
    }
  }

  void _blink() {
    // Save previous state to return to it
    final previousAction = current;

    // Switch to blinking animation
    current = PetAction.blinking;

    final ticker = animationTicker;
    if (ticker != null) {
      ticker.reset();
      ticker.onComplete = () {
        if (current == PetAction.blinking) {
          current = previousAction;
        }
        ticker.onComplete = null;
      };
    }

    _timeUntilBlink = 2.0 + _random.nextDouble() * 4.0;
  }

  void _startRandomWalk() {
    // Avoid walking if dimensions aren't ready
    if (game.size.x <= size.x) return;

    _isWalking = true;

    // Calculate random target within bounds
    final margin = size.x / 2;
    final availableWidth = (game.size.x - size.x).clamp(0, double.infinity);

    // Bottom area (floor)
    final targetX = _random.nextDouble() * availableWidth + margin;
    final baseLineY = game.size.y - (size.y / 2);
    final targetY = baseLineY - 40 - (_random.nextDouble() * 40);
    final target = Vector2(targetX, targetY);

    // Flip sprite based on direction
    if (target.x < position.x && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (target.x > position.x && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    final _ = add(
      MoveToEffect(
        target,
        EffectController(
          speed: 80, // Slightly slower walking
          curve: Curves.easeInOut,
        ),
        onComplete: () {
          _isWalking = false;
          _resetWalkTimer();
        },
      ),
    );
  }

  void _stopWalking() {
    _isWalking = false;
    // Remove any active MoveToEffects
    children.whereType<MoveToEffect>().forEach((e) => e.removeFromParent());
  }

  void _resetWalkTimer() {
    // Random walk every 5-10 seconds
    _timeUntilNextWalk =
        5.0 + (DateTime.now().millisecondsSinceEpoch % 5000) / 1000.0;
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

  @override
  void onTapUp(TapUpEvent event) {
    final selectedTool = game.interactionCubit.state.selectedTool;

    if (selectedTool == GameTool.feed) {
      if (current == PetAction.idle || current == PetAction.sad) {
        final _ = _handleFeeding();
      }
    } else if (selectedTool == GameTool.play) {
      // Placeholder for future tool
    }
    super.onTapUp(event);
  }

  Future<void> _handleFeeding() async {
    final context = game.buildContext;
    if (context == null) return;

    final success = await MathDialog.show(context);

    if (success ?? false) {
      game.petCubit.feed();
    }
  }

  /// Plays a chewing animation (pulsing scale).
  void playChewAnimation() {
    final currentSign = scale.x.sign;
    final pulseScale = _baseGrowthScale * 1.1;
    final _ = add(
      ScaleEffect.to(
        Vector2(currentSign * pulseScale, pulseScale),
        EffectController(
          duration: 0.1,
          reverseDuration: 0.1,
          repeatCount: 5,
        ),
      ),
    );
  }
}
