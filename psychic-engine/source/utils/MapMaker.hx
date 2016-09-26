package utils;

import Random;

import utils.Constants;
import gameData.UserData;

class MapMaker {

  private static var _zoneWidth:Int = 7;
  private static var _zoneHeight:Int = 7;

  private static var _tiles:Array<Array<Int>>;

  public static function getMap():Array<Array<Int>> {
    if(_tiles == null) createMap();
    return _tiles;
  }

  public static function createMap():Void {

    var nZones = Random.int(2, 3);

    var tiles:Array<Array<Int>> = createZone(ZoneKind.starter);

    var kinds = [ZoneKind.normal, ZoneKind.intense];
    for (i in 0...nZones) {
      var zone = createZone(Random.fromArray(kinds));
      for(j in 0...zone.length) {
        tiles[j] = tiles[j].concat(zone[j]);
      }
    }

    _tiles = tiles;
  }

  private static function createZone(kind:ZoneKind):Array<Array<Int>> {
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

      for(i in 0...UserData.heroes.length + 1) {
        var c = Random.int(0, _zoneWidth - 1);
        var l = Random.int(0, _zoneHeight - 1);
        tiles[l][c] = 6;
      }
    }

    return tiles;
  }

  public static function populateZone(nFood:Int, nTreasures:Int, nMonsters:Int, nWalls:Int):Array<Array<Int>> {
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
    while (tilesArray.length < _zoneWidth * _zoneHeight) {
      tilesArray.push(0);
    }
    tilesArray = Random.shuffle(tilesArray);

    for (line in 0..._zoneHeight) {
      var tilesLine = new Array<Int>();
      for (collumn in 0..._zoneWidth) {
        tilesLine.push(tilesArray.pop());
      }
      tiles.push(tilesLine);
    }

    return tiles;
  }

}
