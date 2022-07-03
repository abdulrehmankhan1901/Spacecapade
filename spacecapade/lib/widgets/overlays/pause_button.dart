import 'package:flutter/material.dart';
import 'package:spacecapade/game/game.dart';
import 'package:spacecapade/widgets/overlays/pause_menu.dart';

class PauseButton extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String ID = 'PauseButton';
  final SpacecapadeGame gameRef;

  const PauseButton({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextButton(
          onPressed: () {
            gameRef.pauseEngine();
            gameRef.audioPlayer.stopBgm();
            gameRef.overlays.add(PauseMenu.ID);
            gameRef.overlays.remove(PauseButton.ID);
          },
          child: const Icon(
            Icons.pause_rounded,
            color: Colors.white,
          )),
    );
  }
}
