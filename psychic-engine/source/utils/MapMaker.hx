package utils;

import Random;

import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import gameData.UserData;

class MapMaker {

  private static var _zoneWidth:Int = Constants.ZONE_SIZE;
  private static var _zoneHeight:Int = Constants.ZONE_SIZE;

  private static var _tiles:Array<Array<Int>>;

  private static var _zones:Array<Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>>;

  public static function getMap():Array<Array<Int>> {
    if(_tiles == null) createMap();
    return _tiles;
  }

  public static function getMapZones():Array<Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>> {
    if(_zones == null) createMap();
    return _zones;
  }

  public static function createMap():Void {
    _zones = new Array<Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>>();

    var nZones = Random.int(2, 3);

    var zoneCoord = [0, 0];
    var tiles:Array<Array<Int>> = createZone(ZoneKind.starter, zoneCoord, 0);

    var kinds = [ZoneKind.normal, ZoneKind.intense];

    for (i in 0...nZones) {
      zoneCoord[0] ++;
      //TODO: Use zoneCoord to make a map that is not always the same format
      var zone = createZone(Random.fromArray(kinds), zoneCoord, i + 1);
      for(j in 0...zone.length) {
        tiles[j] = tiles[j].concat(zone[j]);
      }
    }

    _tiles = tiles;
  }

  private static function createZone(kind:ZoneKind, zoneCoord:Array<Int>, name:Int):Array<Array<Int>> {
    var nFood:Int = 0;
    var nTreasures:Int = 0;
    var nMonsters:Int = 0;
    var nWalls:Int = 0;

    switch (kind) {
      case ZoneKind.starter:
        nFood = Random.int(2, 3);
        nMonsters = Random.int(1, 2);
        nWalls = Random.int(0, 4);
      case ZoneKind.normal:
        nFood = Random.int(2, 4);
        nTreasures = Random.int(0, 2);
        nMonsters = Random.int(1, 5);
        nWalls = Random.int(3, 6);
      case ZoneKind.intense:
        nFood = Random.int(3, 5);
        nTreasures = Random.int(0, 4);
        nMonsters = Random.int(5, 8);
        nWalls = Random.int(0, 6);
    }

    var tiles = populateZone(nFood, nTreasures, nMonsters, nWalls);

    if (kind == ZoneKind.starter) tiles[0][0] = 2;

    var zoneInfo = new Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>();
    zoneInfo[ZoneInfo.nTreasures] = nTreasures;
    zoneInfo[ZoneInfo.nMonsters] = nMonsters;
    zoneInfo[ZoneInfo.nFood] = nFood;
    zoneInfo[ZoneInfo.kind] = kind;
    zoneInfo[ZoneInfo.coordX] = zoneCoord[0];
    zoneInfo[ZoneInfo.coordY] = zoneCoord[1];
    zoneInfo[ZoneInfo.name] = name;
    _zones.push(zoneInfo);

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
