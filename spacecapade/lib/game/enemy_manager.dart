import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:spacecapade/game/enemy.dart';
import 'dart:math';

class EnemyManager extends Component with HasGameRef {
  late Timer timer;
  SpriteSheet spritesheet;
  Random random = Random();
  Random randomspriteID = Random();
  late Enemy enemy;

  void spawn() {
    Vector2 pos = Vector2(random.nextDouble() * gameRef.canvasSize.x, 0);
    int spawnID = randomspriteID.nextInt(5);
    Enemy enemy =
        Enemy(sprite: spritesheet.getSpriteById(2), position: pos); //default id
    switch (spawnID) {
      case 0:
        enemy.sprite = spritesheet.getSpriteById(2);
        break;
      case 1:
        enemy.sprite = spritesheet.getSpriteById(7);
        enemy.reward = 1;
        break;
      case 2:
        enemy.sprite = spritesheet.getSpriteById(12);
        enemy.health = 20;
        enemy.reward = 2;
        break;
      case 3:
        enemy.sprite = spritesheet.getSpriteById(17);
        enemy.health = 30;
        enemy.reward = 3;
        break;
      case 4:
        enemy.sprite = spritesheet.getSpriteById(22);
        enemy.health = 50;
        enemy.reward = 5;
        break;
    }
    pos.clamp(
        Vector2.zero() + enemy.size / 2, gameRef.canvasSize - enemy.size / 2);

    enemy.anchor = Anchor.center;
    add(enemy);
  }

  EnemyManager({required this.spritesheet}) : super() {
    timer = Timer(1, onTick: spawn, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }

  void reset() {
    timer.stop();
    timer.start();
  }
}
