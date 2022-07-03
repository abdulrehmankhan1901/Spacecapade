import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacecapade/game/game.dart';

import '../widgets/overlays/gameover_menu.dart';
import '../widgets/overlays/pause_button.dart';

class Enemy extends SpriteComponent with HasGameRef<SpacecapadeGame> {
  double speed = 150;
  int health = 10;
  int reward = 1;

  Random random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(random) - Vector2.random(random)) *
        500; //generate particles
  }

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  ParticleSystemComponent getParticles(Vector2 pos) {
    final ParticleSystemComponent particle = ParticleSystemComponent(
        particle: Particle.generate(
            count: 18,
            lifespan: 0.1,
            generator: (i) => AcceleratedParticle(
                  acceleration: getRandomVector(),
                  speed: getRandomVector(),
                  position: pos + Vector2(0, 0),
                  child: CircleParticle(
                      radius: 1.5,
                      lifespan: 1,
                      paint: Paint()..color = Colors.white),
                  //to: pos + Vector2(0, size.y),
                  //from: pos + Vector2(0, 15),
                )));
    return particle;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, 1) * dt * speed;
    if (position.y > gameRef.canvasSize.y) {
      gameRef.camera.defaultShakeIntensity = 20;
      gameRef.camera.shake();
      gameRef.player.playerHealth = gameRef.player.playerHealth - 1;
      if (gameRef.player.playerHealth <= 0) {
        gameRef.player.playerHealth = 0;
        //display gameover menu
        gameRef.pauseEngine();
        gameRef.overlays.remove(PauseButton.ID);
        gameRef.overlays.add(GameoverMenu.ID);
      }
      gameRef.health.text = 'Health ${gameRef.player.playerHealth}';
      removeFromParent();
    }
  }
}
