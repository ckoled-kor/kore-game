import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import './playerAnimation.dart';

import '../mob.dart';
import '../enemies/enemy.dart';

import '../../../dankGame.dart';

class Player extends SpriteComponent with Destructable implements JoystickListener, Mob {
  final DankGame game;

  double moveRange = 150.0;
  @override
  double damage = 30.0; //30
  @override
  double range = 100.0;
  @override
  double speed = 250.0; //250
  @override
  double maxHealth = 100.0;
  @override
  double health;
  @override
  bool attacking = false;
  @override
  bool isDead = false;
  
  List<Sprite> attackAnim = <Sprite>[
    Sprite('sprites/player/player_attack_01.png'),
    Sprite('sprites/player/player_attack_02.png'),
    Sprite('sprites/player/player.png')
  ];

  List<Sprite> deathAnim = <Sprite>[
    Sprite('sprites/player/player_death_01.png'),
    Sprite('sprites/player/player_death_02.png'),
    Sprite('sprites/player/player_death_03.png'),
    Sprite('sprites/player/player_death_04.png'),
    Sprite('sprites/player/player_death_05.png'),
    Sprite('sprites/player/player_death_06.png'),
  ];

  String attackSound = 'sfx/player/player_attack.mp3';
  String deathSound = 'sfx/player/player_death.mp3';

  double intensity = 0;
  double direction = 0;
  bool _move = false;

  Player(this.game) : super.fromSprite(96.0, 132.0, Sprite('sprites/player/player.png')) {
    health = maxHealth;
  }

  @override
  void attack() {
    if (!attacking) {
      attacking = true;
      if (!game.sfxmuted) Flame.audio.play(attackSound);
      game.add(PlayerAnimation(game.player, attackAnim));
      game.controllers.enemyController.enemies.forEach((Enemy enemy) {
        if (((enemy.x + enemy.width/2) - (x + width/2)).abs() < range && ((enemy.y + enemy.height/2) - (y + height/2)).abs() < range) {
          enemy.health -= damage;
        }
      });
    }
  }

  void respawn() {
    if (isDead = false) game.remove([game.views.playingView]);
    isDead = false;
    health = maxHealth;
    game.spawn([game.views.playingView]);
  }

  @override
  void died() {
    isDead = true;
    health = maxHealth;
    game.huds.itemBar.destroyItem();
    game.huds.helmetSlot.destroyItem();
    if (!game.sfxmuted) Flame.audio.play(deathSound);
    game.add(PlayerAnimation(game.player, deathAnim));
    game.remove([game.views.playingView]);
    game.lvls.currentLvl.levelFail();
  }

  void move() {
    if (!game.barrier.collide(game.player, intensity * speed * cos(direction) / 100.0, intensity * speed * sin(direction) / 100.0)) {
      double centerY = game.size.height - height;
      double centerX = game.size.width - width;

      // blaaaaaarrggg maths not good
      if (game.lvls.currentLvl.y - speed * sin(direction) / 100.0 <= 0 && game.lvls.currentLvl.y - speed * sin(direction) / 100.0 >= -game.lvls.currentLvl.height + game.size.height && (y > centerY / 2 - 5) && (y < centerY / 2 + 5)) {
        game.lvls.currentLvl.moveY(-speed * sin(direction) / 100.0);
      } else if (y + intensity * speed * sin(direction) / 100.0 >= 0 && y + intensity * speed * sin(direction) / 100.0 <= game.size.height - height) {
        y += intensity * speed * sin(direction) / 100.0;
      }
      if (game.lvls.currentLvl.x - speed * cos(direction) / 100.0 <= 0 && game.lvls.currentLvl.x - speed * cos(direction) / 100.0 >= -game.lvls.currentLvl.width + game.size.width && (x > centerX / 2 - 5) && (x < centerX / 2 + 5)) {
        game.lvls.currentLvl.moveX(-speed * cos(direction) / 100.0);
      } else if (x + intensity * speed * cos(direction) / 100.0 >= 0 && x + intensity * speed * cos(direction) / 100.0 <= game.size.width - width) {
        x += intensity * speed * cos(direction) / 100.0;
      }
    }
  }

  @override
  void render(Canvas c) {
    if (!attacking) {
      super.render(c);
    }
  }

  @override
  void update(double t) {
    if (!isDead) {
      if ((health == null) ? false: health > maxHealth) health = maxHealth;
      if ((health == null) ? false: health <= 0) {
        died();
      } else if (_move) {
        move();

        // if (x >= -60 && x <= game.size.width + 10 && y >= -60 && y <= game.size.height + 10) {
        //   x += intensity * speed * cos(direction) / 100.0;
        //   y += intensity * speed * sin(direction) / 100.0;
        // } else {
        //   if (x < -60) {
        //     x += game.size.width + 20;
        //   } else if (x > game.size.width + 10) {
        //     x -= game.size.width + 60;
        //   } else if (y < -60) {
        //     y += game.size.height + 20;
        //   } else if (y > game.size.height + 10) {
        //     y -= game.size.height + 60;
        //   } else {
        //     x = centerX/2;
        //     y = centerY/2;
        //   }
        // }
      }
    }
    
    super.update(t);
  }

  @override
  void resize(Size size) {
    this.x = (size.width - this.width) * 2/5;
    this.y = (size.height - this.height) * 1/5;

    super.resize(size);
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    _move = event.directional != JoystickMoveDirectional.IDLE;

    if (_move && !game.paused) {
      intensity = event.intensity;
      direction = event.radAngle;
    }
  }

  @override
  void joystickAction(JoystickActionEvent event) {}
}