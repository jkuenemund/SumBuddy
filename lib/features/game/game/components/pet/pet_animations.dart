import 'dart:math';

import 'package:flame/components.dart';
import 'package:sum_buddy/features/game/presentation/bloc/pet_state.dart';

/// Handles blinking and waving animations for the Pet.
mixin PetAnimations on SpriteAnimationGroupComponent<PetAction> {
  final Random _random = Random();
  double _timeUntilBlink = 3;
  double _timeUntilWave = 15;

  void updateAnimations(double dt, {required bool isWalking}) {
    // Blinking and Waving logic (only in idle, as assets don't match sad/hungry look)
    final canAnimate = current == PetAction.idle;
    if (canAnimate) {
      _timeUntilBlink -= dt;
      if (_timeUntilBlink <= 0) {
        _blink();
      }

      // Waving logic (triggers after a while of no interaction)
      _timeUntilWave -= dt;
      if (_timeUntilWave <= 0 && !isWalking) {
        _wave();
      }
    } else if (current != PetAction.waving && current != PetAction.blinking) {
      // Reset timer if we are in eating, sad, or other states
      resetWaveTimer();
    }
  }

  void _blink() {
    final previousAction = current;
    current = PetAction.blinking;

    final ticker = animationTicker;
    if (ticker != null) {
      ticker
        ..reset()
        ..onComplete = () {
          if (current == PetAction.blinking) {
            current = previousAction;
          }
          ticker.onComplete = null;
        };
    }

    _timeUntilBlink = 2.0 + _random.nextDouble() * 4.0;
  }

  void _wave() {
    final previousAction = current;
    current = PetAction.waving;

    final ticker = animationTicker;
    if (ticker != null) {
      ticker
        ..reset()
        ..onComplete = () {
          if (current == PetAction.waving) {
            current = previousAction;
          }
          ticker.onComplete = null;
        };
    }
    resetWaveTimer();
  }

  void resetWaveTimer() {
    _timeUntilWave = 15.0 + _random.nextDouble() * 10.0;
  }
}
