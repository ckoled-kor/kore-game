import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';

import './enemy.dart';
import './enemyAnimation.dart';
import './enemyHealthBar.dart';

import '../../../destructable.dart';
import '../../../dankGame.dart';

class BasicEnemy extends SpriteComponent with Destructable implements Enemy {
  @override
  DankGame game;
  @override
  EnemyHealthBar enemyHealthBar;
  @override
  bool isDead = false;
  @override
  double speed = 150.0;
  @override
  double maxHealth = 50.0;
  @override
  double damage = 50.0;
  @override
  double range = 50.0;
  @override
  double attackSpeed = 1;

  @override
  double health;

  @override
  List<Sprite> attackAnim = <Sprite>[
    Sprite('sprites/enemies/basic_enemy_attack_01.png'),
    Sprite('sprites/enemies/basic_enemy_attack_02.png'),
    Sprite('sprites/enemies/basic_enemy.png')
  ];

  @override
  List<Sprite> deathAnim = <Sprite>[
    Sprite('sprites/enemies/basic_enemy_death_01.png'),
    Sprite('sprites/enemies/basic_enemy_death_02.png'),
    Sprite('sprites/enemies/basic_enemy_death_03.png'),
    Sprite('sprites/enemies/basic_enemy_death_04.png'),
  ];

  BasicEnemy(this.game) : super.fromSprite(72.0, 64.0, Sprite('sprites/enemies/basic_enemy.png')) {
    health = maxHealth;
    enemyHealthBar = EnemyHealthBar(this);
    game.add(enemyHealthBar);
  }

  @override
  void died() {
    if (!isDead) {
      isDead = true;
      health = maxHealth;
      game.add(EnemyAnimation(this, deathAnim));
      game.remove([this, enemyHealthBar]);
    }
  }

  @override
  void update(double t) {
    if (!isDead && health <= 0) {
      died();
    } else if (!isDead) {
      x += (game.player.x - x) / (10000/speed);
      y += (game.player.y - y) / (10000/speed);

      if ((game.player.x - x).abs() < range && (game.player.y - y).abs() < range) {
        attack();
      }
    }

    super.update(t);
  }

  @override
  void attack() {
    if (DateTime.now().millisecondsSinceEpoch % (1000 / attackSpeed) <= 100) {
      game.add(EnemyAnimation(this, attackAnim));
      game.player.health -= damage / 10;
    } 
  }
}