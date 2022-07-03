import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:spacecapade/game/game.dart';
import 'package:spacecapade/widgets/overlays/fire_button.dart';
import 'package:spacecapade/widgets/overlays/pause_button.dart';
import 'package:spacecapade/widgets/overlays/pause_menu.dart';

import '../widgets/overlays/gameover_menu.dart';

SpacecapadeGame _spacecapadeGame = SpacecapadeGame();
var overlayMap = {
  PauseButton.ID: (BuildContext context, SpacecapadeGame gameRef) =>
      PauseButton(
        gameRef: gameRef,
      ),
  PauseMenu.ID: (BuildContext context, SpacecapadeGame gameRef) => PauseMenu(
        gameRef: gameRef,
      ),
  FireButton.ID: (BuildContext context, SpacecapadeGame gameRef) => FireButton(
        gameRef: gameRef,
      ),
  GameoverMenu.ID: (BuildContext context, SpacecapadeGame gameRef) =>
      GameoverMenu(
        gameRef: gameRef,
      ),
};

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _spacecapadeGame,
          overlayBuilderMap: overlayMap,
          // ignore: prefer_const_literals_to_create_immutables
          initialActiveOverlays: [PauseButton.ID, FireButton.ID],
        ),
      ),
    );
  }
}
