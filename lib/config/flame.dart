import 'package:flame/flame.dart';
import 'package:flame/util.dart';

import '../bgm.dart';

class _Flame {
  Util flameUtil;

  Future<void> init() async {
    flameUtil = Util();
    await flameUtil.fullScreen();
    await flameUtil.setPortrait();

    await Flame.images.loadAll(<String>[
      'bg/background.jpg',
      'bg/level_01.jpg',

      'branding/logo.png',
      'branding/spritesheet.png',

      'ui/game_over.png',
      'ui/restart.png',
      'ui/start.png',
      'ui/game_over.png',
      'ui/healthbar.png',

      'sprites/player/player.png',
      'sprites/player/player_attack_01.png',
      'sprites/player/player_attack_02.png',
      'sprites/player/player_death_01.png',
      'sprites/player/player_death_02.png',
      'sprites/player/player_death_03.png',
      'sprites/player/player_death_04.png',
      'sprites/player/player_death_05.png',
      'sprites/player/player_death_06.png',

      'sprites/enemies/basic_enemy.png',
      'sprites/enemies/basic_enemy_attack_01.png',
      'sprites/enemies/basic_enemy_attack_02.png',
      'sprites/enemies/basic_enemy_death_01.png',
      'sprites/enemies/basic_enemy_death_02.png',
      'sprites/enemies/basic_enemy_death_03.png',
      'sprites/enemies/basic_enemy_death_04.png',

      'sprites/enemies/rare_enemy.png',
      'sprites/enemies/rare_enemy_attack_01.png',
      'sprites/enemies/rare_enemy_attack_02.png',
      'sprites/enemies/rare_enemy_attack_03.png',
      'sprites/enemies/rare_enemy_attack_04.png',
      'sprites/enemies/rare_enemy_death_01.png',
      'sprites/enemies/rare_enemy_death_02.png',
      'sprites/enemies/rare_enemy_death_03.png',
      'sprites/enemies/rare_enemy_death_04.png',
    ]);

    Flame.audio.disableLog();
    await Flame.audio.loadAll(<String>[]);
  }
}
final _Flame flame = _Flame();