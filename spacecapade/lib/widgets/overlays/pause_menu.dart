// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:spacecapade/widgets/overlays/pause_button.dart';

import '../../game/game.dart';
import '../../screens/mainmenu.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);
  // ignore: constant_identifier_names
  static const String ID = 'PauseMenu';
  final SpacecapadeGame gameRef;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              "PAUSED",
              style: TextStyle(fontSize: 40, shadows: [
                Shadow(
                    blurRadius: 20, color: Colors.white, offset: Offset(0, 0))
              ]),
            )),
        //Resume button
        SizedBox(
          width:
              MediaQuery.of(context).size.width / 3, //set size to 1/3 of scren
          child: ElevatedButton(
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.audioPlayer.playBgm('spaceman.wav');
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
              },
              child: const Text("Resume")),
        ),
        //Restart Button
        SizedBox(
          width:
              MediaQuery.of(context).size.width / 3, //set size to 1/3 of scren
          child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.reset();
                gameRef.audioPlayer.stopBgm();
                gameRef.resumeEngine();
                gameRef.audioPlayer.playBgm('spaceman.wav');
              },
              child: Text("Restart")),
        ),
        //Exit button
        SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.resumeEngine();
                gameRef.reset();
                gameRef.audioPlayer.stopBgm();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainMenu()));
              },
              child: Text("Exit"),
            )),
      ]),
    );
  }
}
