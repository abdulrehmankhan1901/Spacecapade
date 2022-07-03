import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecapade/details/player_details.dart';
import 'package:spacecapade/details/ship_details.dart';
import 'package:spacecapade/screens/mainmenu.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'game_play.dart';

class SelectShip extends StatelessWidget {
  const SelectShip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //int index = 0;
    //final spaceship = Spaceship.ships.entries.elementAt(index).value;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                "SELECT SHIP",
                style: TextStyle(fontSize: 40, shadows: [
                  Shadow(
                      blurRadius: 20, color: Colors.white, offset: Offset(0, 0))
                ]),
              )),
          Consumer<PlayerDetails>(builder: (context, playerData, child) {
            final spaceship = Spaceship(4, 'assets/images/ship1.png', 0)
                .getSpaceshipByName(playerData.name);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Current Ship: ${spaceship.name}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Money: ${playerData.money}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.5, //set height to half of current device
            child: CarouselSlider.builder(
                itemCount: Spaceship.ships.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  final spaceship =
                      Spaceship.ships.entries.elementAt(itemIndex).value;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(spaceship.assetPath),
                      const SizedBox(
                        height: 11.5,
                      ),
                      Text('${spaceship.name}'),
                      Text('Speed: ${spaceship.speed}'),
                      Text('Level: ${spaceship.lvl}'),
                      Text('Cost: ${spaceship.cost}'),
                      Consumer<PlayerDetails>(
                        //this consumer listens to player details
                        builder: (context, playerDetails, child) {
                          final ship =
                              Spaceship.ships.entries.elementAt(itemIndex).key;
                          final isEquipped = playerDetails.isEquipped(ship);
                          final isOwned = playerDetails.isOwned(ship);
                          final canBuy = playerDetails.canBuy(ship);
                          return ElevatedButton(
                              onPressed: isEquipped
                                  ? null
                                  : () {
                                      if (isOwned) {
                                        playerDetails.equip(ship);
                                      } else {
                                        if (canBuy) {
                                          playerDetails.buy(ship);
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Not enough money',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Text(
                                                    'Need ${spaceship.cost - playerDetails.money} more',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              });
                                        }
                                      }
                                    },
                              child: Text(isEquipped
                                  ? 'Equipped'
                                  : isOwned
                                      ? 'Select'
                                      : 'Buy'));
                        },
                      ),
                    ],
                  );
                },
                options: CarouselOptions()),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width /
                3, //set size to 1/3 of scren
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GamePlay()));
                },
                child: const Text("Start")),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MainMenu()));
                },
                child: const Icon(Icons.arrow_back_ios_new),
              )),
        ],
      ),
    ));
  }
}
