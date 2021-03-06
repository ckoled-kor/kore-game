import 'package:flame/sprite.dart';

import './item.dart';

import '../../dankGame.dart';

class BasicHeal extends Item {
  BasicHeal(DankGame game) : super(game, type: ItemType.CONSUMABLE, width: 90, height: 90, sprite: Sprite('items/basic_heal.png'), useSound: 'sfx/player/basic_heal.mp3');

  @override
  void use() {
    if (!game.player.isDead) game.player.health += game.player.maxHealth * .1;
    super.use();
  }
}