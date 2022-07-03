// ignore_for_file: prefer_const_constructors

//import 'package:flame/components.dart';
import 'package:flutter/material.dart';
//import 'package:spacecapade/game/game.dart';
import 'package:spacecapade/screens/game_play.dart';
import 'package:spacecapade/screens/upgrade_ship.dart';

import 'logIn.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                "SPACECAPADE",
                style: TextStyle(fontSize: 40, shadows: [
                  Shadow(
                      blurRadius: 20, color: Colors.white, offset: Offset(0, 0))
                ]),
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width /
                3, //set size to 1/3 of scren
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GamePlay()));
                },
                child: Text("Play")),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const SelectShip()));
                },
                child: Text("Upgrade Ship"),
              )),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LogIn()));
                },
                child: Text("Scores"),
              )),
        ],
      ),
    ));
  }
}
