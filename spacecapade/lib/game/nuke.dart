import 'package:flame/components.dart';
import 'package:spacecapade/game/enemy.dart';
import 'package:spacecapade/game/game.dart';

class Nuke extends SpriteComponent {
  late SpacecapadeGame gameRef;
  late Timer timer;

  Nuke({
    required this.gameRef,
    Vector2? position,
    Vector2? size,
    Sprite? sprite,
  }) : super(position: position, size: size, sprite: sprite) {
    timer = Timer(3);
  }

  void getPower() {
    for (final enemy in gameRef.enemyManager.children.whereType<Enemy>()) {
      enemy.removeFromParent();
      add(enemy.getParticles(enemy.position));
      gameRef.player.addToScore(5);
      gameRef.score.text = 'Score ${gameRef.player.playerScore}';
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    position =
        gameRef.canvasSize + Vector2(250, 250); //remove powerup from screen
  }

  @override
  void update(double dt) {
    timer.update(dt);
    if (timer.finished) {
      removeFromParent();
      gameRef.alreadyNuke = false;
    }
    super.update(dt);
  }

  @override
  void onMount() {
    timer.start();
    super.onMount();
  }
}
