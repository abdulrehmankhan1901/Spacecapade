// ignore_for_file: unnecessary_this

import 'package:flutter/cupertino.dart';
import 'package:spacecapade/details/ship_details.dart';
//import 'package:hive/hive.dart'; /// hive not implemented due to change in usage

// for saving player details

class PlayerDetails extends ChangeNotifier {
  ShipName name;

  final List<ShipName> owned;

  final int highscore;

  int money;

  PlayerDetails(this.name, this.owned, this.highscore, this.money);

  PlayerDetails.fromMap(Map<String, dynamic> map)
      : this.name = map['currentShip'],
        this.owned = map['ownedShips']
            .map((e) => e as ShipName)
            .cast<ShipName>()
            .toList(),
        this.highscore = map['highscore'],
        this.money = map['money'];
  static Map<String, dynamic> defaultDetails = {
    'currentShip': ShipName.Albatros1,
    'ownedShips': [],
    'highscore': 0,
    'money': 0
  };

  bool isOwned(ShipName name) {
    return owned.contains(name);
  }

  bool canBuy(ShipName name) {
    return this.money >=
        Spaceship(4, 'assets/images/ship1.png', 0)
            .getSpaceshipByName(name)
            .cost;
  }

  bool isEquipped(ShipName name) {
    return (this.name == name);
  }

  void buy(ShipName name) {
    if (canBuy(name) && (!isOwned(name))) {
      money -= Spaceship(4, 'assets/images/ship1.png', 0).cost;
      owned.add(name);
      notifyListeners(); // state of player details changed
    }
  }

  void equip(ShipName name) {
    this.name = name;
    notifyListeners();
  }
}
