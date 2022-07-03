//import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
//import 'package:flame/game.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:spacecapade/details/player_details.dart';
//import 'package:spacecapade/game/game.dart';
import 'package:spacecapade/screens/mainmenu.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //call flame code before runapp
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyC5wR80qrPuiCN1Yk_HP8sll9shUO9qgoQ',
          appId: '1:520288192960:android:e7d2d24ac528ae5bc1e025',
          messagingSenderId: '520288192960',
          projectId: 'project-1105-1086'));
  Flame.device.fullScreen();
  runApp(
      //GameWidget(
      //  game: SpacecapadeGame(),
      //), //injects the widget of flame game into flutter widget tree
      // from provider package
      ChangeNotifierProvider(
    create: (context) => PlayerDetails.fromMap(PlayerDetails.defaultDetails),
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainMenu(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'BungeeInLine',
          scaffoldBackgroundColor: Colors.black,
        )),
  ));
}
