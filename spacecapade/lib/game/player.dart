import 'dart:math';
//import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecapade/details/player_details.dart';
import 'package:spacecapade/details/ship_details.dart';
import 'package:spacecapade/game/game.dart';

class Player extends SpriteComponent with HasGameRef<SpacecapadeGame> {
  //final double speed = 300;
  int playerScore = 0;
  int playerHealth = 10;
  late PlayerDetails playerDetails;

  ShipName shipName;
  Spaceship spaceship;

  Random random = Random();
  Vector2 getRandomVector() {
    return (Vector2.random(random) - Vector2(0.5, -1)) *
        200; //generate particles
  }

  Player({
    required this.shipName,
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  })  : spaceship = Spaceship(4, 'assets/images/ship1.png', 0)
            .getSpaceshipByName(shipName),
        super(sprite: sprite, position: position, size: size);

  ParticleSystemComponent getParticles(Vector2 pos) {
    final ParticleSystemComponent particle = ParticleSystemComponent(
        particle: Particle.generate(
            count: 10,
            lifespan: 0.1,
            generator: (i) => AcceleratedParticle(
                  acceleration: getRandomVector(),
                  speed: getRandomVector(),
                  position: pos + Vector2(0, size.y / 3),
                  child: CircleParticle(
                      radius: 1,
                      lifespan: 1,
                      paint: Paint()..color = Colors.white),
                  //to: pos + Vector2(0, size.y),
                  //from: pos + Vector2(0, 15),
                )));
    return particle;
  }

  void movePlayer(double dt, var direction) {
    position.add(direction * spaceship.speed * dt);
  }

  void addToScore(int value) {
    playerScore = playerScore + value;
    playerDetails.money += value;
  }

  void setShipName(ShipName name) {
    shipName = name;
    spaceship =
        Spaceship(4, 'assets/images/ship1.png', 0).getSpaceshipByName(name);
    sprite = gameRef.spritesheet.getSpriteById(spaceship.spriteID);
  }

  @override
  void onMount() {
    super.onMount();
    //build context cannot be null, hence used ! here
    playerDetails =
        Provider.of<PlayerDetails>(gameRef.buildContext!, listen: false);
  }

  void reset() {
    position = gameRef.canvasSize / 2;
    playerScore = 0;
    playerHealth = 10;
  }
}
