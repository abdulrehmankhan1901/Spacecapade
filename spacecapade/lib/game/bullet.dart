import 'package:flame/components.dart';

class Bullet extends SpriteComponent with HasGameRef {
  double speed = 450;

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, -1) * speed * dt; //move in upward direction
    if (position.y > gameRef.canvasSize.y) {
      removeFromParent();
    }
  }
}
