//import 'package:hive/hive.dart';  /// hive not implemented due to change in usage

class Spaceship {
  String? name = '';
  int cost = 0;
  double? speed = 300;
  int spriteID = 4;
  String assetPath = 'assets/images/ship1.png';
  int? lvl = 1;

  Spaceship(this.spriteID, this.assetPath, this.cost,
      [this.name, this.speed, this.lvl]);
  // only static fields can be marked as const
  static Map<ShipName, Spaceship> ships = {
    ShipName.Albatros1:
        Spaceship(4, 'assets/images/ship1.png', 0, 'Albatros-1', 300, 1),
    ShipName.Albatros2:
        Spaceship(9, 'assets/images/ship2.png', 100, 'Albatros-2', 200, 2),
    ShipName.Albatros3:
        Spaceship(14, 'assets/images/ship3.png', 500, 'Albatros-3', 400, 3),
  };

  Spaceship getSpaceshipByName(ShipName name) {
    return ships[name] ??
        ships.entries.first.value; //if no value, then return first spaceship
  }
}

//for easier identification
// ignore: constant_identifier_names
enum ShipName { Albatros1, Albatros2, Albatros3 }
