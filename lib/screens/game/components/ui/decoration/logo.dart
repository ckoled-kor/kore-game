import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

import '../../../dankGame.dart';

class Logo extends AnimationComponent with Destructable {
  final DankGame game;
  
  static final SpriteSheet logoSheet = SpriteSheet(
      columns: 80,
      rows: 1,
      imageName: 'branding/spritesheet.png',
      textureWidth: 205,
      textureHeight: 200,
    );

  Logo(this.game) : super(game.size.width + 20, game.size.height * 2/3, logoSheet.createAnimation(0, stepTime: 0.1));

  @override
  void resize(Size size) {
    this.x = (size.width - this.width) / 2;
    this.y = (size.height - this.height) * 1/4;

    super.resize(size);
  }
}