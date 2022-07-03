import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spacecapade/game/bullet.dart';
import 'package:spacecapade/game/game.dart';
//import 'package:spacecapade/widgets/overlays/pause_menu.dart';

class FireButton extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String ID = 'FireButton';
  final SpacecapadeGame gameRef;

  const FireButton({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        // ignore: sized_box_for_whitespace
        child: Container(
          height: 100,
          width: 100,
          child: RawMaterialButton(
            shape: const CircleBorder(),
            elevation: 0,
            child: Image.asset('assets/images/fire.png'),
            onPressed: () {
              Bullet bullet = Bullet(
                sprite: gameRef.spritesheet.getSpriteById(19),
                position: gameRef.player.position,
              );
              bullet.anchor = Anchor.center;
              gameRef.add(bullet);
              gameRef.audioPlayer.playSfx('laser1.ogg');
            },
          ),
        ));
  }
}
