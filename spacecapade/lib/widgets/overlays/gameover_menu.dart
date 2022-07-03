import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spacecapade/widgets/overlays/pause_button.dart';

import '../../game/game.dart';
import '../../screens/mainmenu.dart';

class GameoverMenu extends StatelessWidget {
  const GameoverMenu({Key? key, required this.gameRef}) : super(key: key);
  // ignore: constant_identifier_names
  static const String ID = 'GameoverMenu';
  final SpacecapadeGame gameRef;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? username;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              "GAME OVER",
              style: TextStyle(fontSize: 40, shadows: [
                Shadow(
                    blurRadius: 20, color: Colors.white, offset: Offset(0, 0))
              ]),
            )),
        SizedBox(
          child: TextField(
            onChanged: (value) {
              username = value;
            },
            decoration: const InputDecoration(
              helperText: 'Enter username to save score.',
              icon: Icon(Icons.person),
            ),
          ),
        ),
        //Save Button
        SizedBox(
          width:
              MediaQuery.of(context).size.width / 3, //set size to 1/3 of scren
          child: ElevatedButton(
              onPressed: () {
                var errorCode;
                if (username != null) {
                  try {
                    users.add({
                      'username': username,
                      'score': gameRef.player.playerScore.toString(),
                    });
                  } catch (e) {
                    errorCode = e;
                  }
                  if (errorCode != null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("ERROR"),
                            content: Text(errorCode.toString()),
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          username = null;
                          return const AlertDialog(
                            title: Text("SUCCESS"),
                            content: Text("Record added sucessfully"),
                          );
                        });
                  }
                }
              },
              child: const Text("Save")),
        ),
        //Restart Button
        SizedBox(
          width:
              MediaQuery.of(context).size.width / 3, //set size to 1/3 of scren
          child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(GameoverMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text("Restart")),
        ),
        //Exit button
        SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(GameoverMenu.ID);
                gameRef.overlays.add(PauseButton.ID);
                gameRef.resumeEngine();
                gameRef.reset();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainMenu()));
              },
              child: const Text("Exit"),
            )),
      ]),
    );
  }
}
