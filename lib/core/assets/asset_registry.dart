/// Registry for all game assets to avoid hardcoding strings.
class AssetRegistry {
  const AssetRegistry._();

  static const images = _GameImages();
  static const room = _RoomImages();
}

class _RoomImages {
  const _RoomImages();

  String get background => 'room/bg_empty.png';
  String get rug => 'room/furnuture_rug_yellow.png';
  String get sofa => 'room/furniture_sofa_green.png';
  String get petBed => 'room/furniture_pet_bed_blue.png';
}

class _GameImages {
  const _GameImages();

  String get background => 'background.png';
  String get petIdle => 'pet_idle.png';
  String get petBlink => 'pet_blink_test.png';
  String get petWave => 'pet_wave.png';
  String get petEating => 'pet_eating.png';
  String get petSad => 'pet_sad.png';
  String get foodCookie => 'food_cookie.png';
  String get foodCake => 'food_cake.png';
  String get foodApple => 'food_apple.png';
}
