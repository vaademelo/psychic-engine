package utils;

import Random;

import gameData.UserData;

enum ZoneKind {
  starter;
  normal;
  intense;
}

class MapMaker {

  private var _zoneWidth:Int = 7;
  private var _zoneHeight:Int = 7;

  public function createMap() {

    var nZones = Random.int(2, 3);

    var tiles:Array<Array<Int>> = new Array<Array<Int>>();

    //TODO: finish creating map

  }

  public function createZone(kind:ZoneKind):Array<Array<Int>> {
    var nFood:Int = 0;
    var nTreasures:Int = 0;
    var nMonsters:Int = 0;
    var nWalls:Int = 0;

    switch (kind) {
      case ZoneKind.starter:
        nFood = Random.int(2, 3);
        nMonsters = Random.int(0, 1);
        nWalls = Random.int(0, 4);
      case ZoneKind.normal:
        nFood = Random.int(2, 4);
        nTreasures = Random.int(0, 2);
        nMonsters = Random.int(0, 6);
        nWalls = Random.int(3, 6);
      case ZoneKind.intense:
        nFood = Random.int(3, 5);
        nTreasures = Random.int(0, 4);
        nMonsters = Random.int(6, 9);
        nWalls = Random.int(0, 6);
    }


    var tiles = populateZone(nFood, nTreasures, nMonsters, nWalls);

    if (kind == ZoneKind.starter) {
      tiles[0][0] = 2;
      UserData.loadUserData();

      for(i in 0...UserData.heroes.lenght + 1) {
        var c = Random.int(0, _zoneWidth);
        var l = Random.int(0, _zoneHeight);
        tiles[l][c] = 6;
      }
    }

    return tiles;
  }

  public function populateZone(nFood:Int, nTreasures:Int, nMonsters:Int, nWalls:Int):Array<Array<Int>> {
    var tiles:Array<Array<Int>> = new Array<Array<Int>>();

    var tilesArray:Array<Int> = new Array<Int>();
    while (nWalls > 0) {
      tilesArray.push(1);
      nWalls --;
    }
    while (nFood > 0) {
      tilesArray.push(3);
      nFood --;
    }
    while (nTreasures > 0) {
      tilesArray.push(4);
      nTreasures --;
    }
    while (nMonsters > 0) {
      tilesArray.push(5);
      nMonsters --;
    }
    while (tilesArray.lenght < _zoneWidth * _zoneHeight) {
      tilesArray.push(0);
    }
    tilesArray = Random.shuffle(tilesArray);

    for (line in _zoneHeight) {
      var tilesLine = new Array<Int>();
      for (collumn in _zoneWidth) {
        tilesLine.push(tilesArray.pop());
      }
      tiles.push(tiles);
    }

    return tiles;
  }

}
