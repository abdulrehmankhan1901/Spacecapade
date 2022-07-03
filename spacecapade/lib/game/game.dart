import 'dart:math';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
//import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
//import 'package:flame/text.dart';
import 'package:flame/widgets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecapade/details/player_details.dart';
import 'package:spacecapade/details/ship_details.dart';
import 'package:spacecapade/game/audio_player.dart';
import 'package:spacecapade/game/enemy.dart';
import 'package:spacecapade/game/enemy_manager.dart';
import 'package:spacecapade/game/player.dart';
import 'package:spacecapade/game/nuke.dart';
import 'package:spacecapade/widgets/overlays/gameover_menu.dart';
import 'package:spacecapade/widgets/overlays/pause_button.dart';
import 'package:spacecapade/widgets/overlays/pause_menu.dart';
import 'bullet.dart';
//import 'fire_Button.dart';

/// sfx don't work, they work in the web version
/// unable to save progress due to change in hive's documentation and bugs
/// game sometimes crashes due to excessive action button presses, reason unknown
/// overlay text fields don't accept input in web versions

//Responsible for Gameloop

class SpacecapadeGame extends FlameGame with HasDraggables, HasTappables {
  late final JoystickComponent joystick;
  late Player player;
  late SpriteButton fireButton;
  Future<Sprite> fire = Sprite.load('fire.png');
  late TextComponent health; //for displaying health
  late TextComponent score; //for displaying score
  late SpriteSheet spritesheet;
  late EnemyManager enemyManager;
  late Bullet bullet;
  late Nuke nuke;
  late AudioPlayer audioPlayer;
  Random random = Random();
  int spawnPowerup = 0;
  bool alreadyNuke = false;
  bool alreadyLoadeed = false; //prevents making of multiple game worlds

  @override
  //load required assets before the game starts
  Future<void>? onLoad() async {
    if (!alreadyLoadeed) {
      await images
          .loadAll(['sheet.png', 'freeze.png', 'nuke.png', 'multi_fire.png']);

      spritesheet = SpriteSheet.fromColumnsAndRows(
          image: images.fromCache('sheet.png'), columns: 5, rows: 5);

      await FlameAudio.audioCache
          .loadAll(['laser1.ogg', 'powerUp6.ogg', 'spaceTrash5.ogg']);

//player

      const shipname = ShipName.Albatros1;
      final spaceship = Spaceship(4, 'assets/images/ship1.png', 0)
          .getSpaceshipByName(shipname);

      player = Player(
        shipName: shipname,
        sprite: spritesheet.getSpriteById(spaceship.spriteID),
        //size: Vector2(64, 55),
        position: canvasSize / 2, //spawn point
      );
      player.anchor = Anchor.center; //place spwan point at center of the screen
      add(player); //add to the gameworld
//enemy
      enemyManager = EnemyManager(spritesheet: spritesheet);
      add(enemyManager);
//joystick
      joystick = JoystickComponent(
        knob: CircleComponent(
            radius: 20, paint: BasicPalette.blue.withAlpha(200).paint()),
        background: CircleComponent(
            radius: 40, paint: BasicPalette.blue.withAlpha(100).paint()),
        margin: const EdgeInsets.only(left: 40, bottom: 40),
      );
      add(joystick); //add joystick to gameworld

//player score
      score = TextComponent(
        scale: Vector2(0.5, 0.5),
        text: 'Score  0',
        position: Vector2(10, 10),
      );
      add(score);
//player health
      health = TextComponent(
        scale: Vector2(0.5, 0.5),
        text: 'Health  10',
        position: Vector2(canvasSize.x - 10, 10),
      );
      health.anchor = Anchor.topRight;
      add(health);

      nuke = Nuke(
          size: Vector2(35, 35),
          sprite: Sprite(images.fromCache('nuke.png')),
          position: canvasSize + Vector2(250, 250),
          gameRef: this);

      //audio player
      audioPlayer = AudioPlayer();
      add(audioPlayer);
      //audioPlayer.playBgm('spaceman.wav');

      alreadyNuke = false;
      alreadyLoadeed = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.movePlayer(dt, joystick.relativeDelta); //updates player position
    player.position.clamp(
        Vector2.zero() + player.size / 2,
        canvasSize -
            player.size / 2); //prevents player from moving out of bounds
    add(player.getParticles(player.position));
    // detect collision
    final bullets = children.whereType<Bullet>();
    for (final enemy in enemyManager.children.whereType<Enemy>()) {
      for (final bl in bullets) {
        if (enemy.containsPoint(bl.absoluteCenter)) {
          enemy.health -= 10;
          if (enemy.health <= 0) {
            player.addToScore(enemy.reward);
            enemy.removeFromParent();
            FlameAudio.play('spaceTrash5.ogg', volume: 1);
          }
          bl.removeFromParent();
          spawnPowerup =
              random.nextInt(20); //decreased the rate of nuke spwaning
          //nuke can spawn even when hitting the enemy
          add(enemy.getParticles(enemy.position));
          if (spawnPowerup == 2 && !alreadyNuke) {
            nuke.position = enemy.position;
            add(nuke);
            alreadyNuke = true;
          }
          score.text = 'Score ${player.playerScore}';
          break;
        }
      }
      if (player.containsPoint(enemy.absoluteCenter)) {
        //each update, gets called 13 times
        enemy.removeFromParent();
        camera.defaultShakeIntensity = 20;
        camera.shake();
        player.playerHealth -= 1;
        if (player.playerHealth <= 0) {
          player.playerHealth = 0;
          //display gameover menu
          pauseEngine();
          overlays.remove(PauseButton.ID);
          overlays.add(GameoverMenu.ID);
        }
        health.text = 'Health ${player.playerHealth}';
      }
    }
    if (nuke.containsPoint(player.absoluteCenter)) {
      nuke.getPower();
      audioPlayer.playSfx('powerUp6.ogg');
      nuke.removeFromParent();
      alreadyNuke = false;
    }
  }

  @override
  void onAttach() {
    super.onAttach();
    if (buildContext != null) {
      final playerDetails =
          Provider.of<PlayerDetails>(buildContext!, listen: false);
      player.setShipName(playerDetails.name);
    }
    audioPlayer.playBgm('spaceman.wav');
  }

  @override
  void onDetach() {
    audioPlayer.stopBgm();
    super.onDetach();
  }

  // @override
  // void onTapDown(int pointerId, TapDownInfo info) {
  //   super.onTapDown(pointerId, info);
  //   bullet = Bullet(
  //     sprite: spritesheet.getSpriteById(19),
  //     position: player.position,
  //   );
  //   bullet.anchor = Anchor.center;
  //   add(bullet);
  // }

  //called when game is sent to background
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (player.playerHealth > 0) {
          pauseEngine();
          overlays.remove(PauseButton.ID);
          overlays.add(PauseMenu.ID);
        }
        break;
    }
    super.lifecycleStateChange(state);
  }

  void reset() {
    enemyManager.children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });
    children.whereType<Bullet>().forEach((bl) {
      bl.removeFromParent();
    });
    score.text = 'Score 0';
    health.text = 'Health 10';
    player.reset();
    enemyManager.reset();
  }
}
