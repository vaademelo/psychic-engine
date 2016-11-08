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
    var usedZoneCoord:Array<Array<Int>> = new Array<Array<Int>>();
    var createdZones = new Array<Array<Array<Int>>>();
    var tiles:Array<Array<Int>> = new Array<Array<Int>>();
    var nZones = 6;
    var zoneCoord = [0, 0];
    var kinds = [ZoneKind.normal, ZoneKind.intense];

    usedZoneCoord.push([zoneCoord[0],zoneCoord[1]]);
    createdZones.push(createZone(ZoneKind.starter, zoneCoord, 0));

    for (i in 0...nZones) {
      zoneCoord = nextZoneCoord(usedZoneCoord);
      usedZoneCoord.push([zoneCoord[0],zoneCoord[1]]);
      createdZones.push(createZone(Random.fromArray(kinds), zoneCoord, 0));
    }

    var limits:Map<String, Int> = zonesLimits(usedZoneCoord);
    tiles = initializeTiles(limits);

    for (j in 0...(limits["jMax"] - limits["jMin"] + 1)) {
      for (i in 0...(limits["iMax"] - limits["iMin"] + 1)) {

        if (!coordinateHasZone(usedZoneCoord, [limits["iMin"] + i, limits["jMin"] + j])) {
          for (k in 0...(Constants.ZONE_SIZE)) {
            tiles[k + (j * Constants.ZONE_SIZE)] = tiles[k + (j * Constants.ZONE_SIZE)].concat([8,8,8,8,8,8,8]);
          }

        } else {

          var zone:Array<Array<Int>> = createdZones[zoneIndex(usedZoneCoord, [limits["iMin"] + i, limits["jMin"] + j])];
          for (k in 0...(Constants.ZONE_SIZE)) {
            tiles[k + (j * Constants.ZONE_SIZE)] = tiles[k + (j * Constants.ZONE_SIZE)].concat(zone[k]);
          }
        }
      }
    }
    _tiles = tiles;
  }

  private static function initializeTiles(limits:Map<String, Int>):Array<Array<Int>> {
    var tiles:Array<Array<Int>> = [];
    for (j in 0...((limits["jMax"] - limits["jMin"] + 1) * Constants.ZONE_SIZE)) {
      tiles.push([]);
    }
    return tiles;
  }

  private static function zoneIndex(usedZoneCoord:Array<Array<Int>>, coordinate:Array<Int>){
    for (i in 0...usedZoneCoord.length) {
      if(coordinate[0] == usedZoneCoord[i][0] && coordinate[1] == usedZoneCoord[i][1]) {
        return i;
      }
    }
    return -1;
  }

  private static function coordinateHasZone(usedZoneCoord:Array<Array<Int>>, coordinate:Array<Int>):Bool {
    for (usedCoordinate in usedZoneCoord) {
      if(coordinate[0] == usedCoordinate[0] && coordinate[1] == usedCoordinate[1]) {
        return true;
      }
    }
    return false;
  }

  private static function zonesLimits(usedZoneCoord:Array<Array<Int>>):Map<String, Int> {
    var limits:Map<String, Int> = ["iMax" => -42, "iMin" => 42, "jMax" => -42, "jMin" => 42];

    for (coordinate in usedZoneCoord){
      if(coordinate[0] > limits["iMax"])
        limits["iMax"] = coordinate[0];
      if(coordinate[0] < limits["iMin"])
        limits["iMin"] = coordinate[0];
      if(coordinate[1] > limits["jMax"])
        limits["jMax"] = coordinate[1];
      if(coordinate[1] < limits["jMin"])
        limits["jMin"] = coordinate[1];
    }
    return limits;
  }

  private static function nextZoneCoord(usedZoneCoord:Array<Array<Int>>):Array<Int> {
    var zoneCoord = [];
    var lastCoord = usedZoneCoord[usedZoneCoord.length - 1];

    var availableDirections = [];

    if (isCoordinateAvailable([lastCoord[0], lastCoord[1] - 1], usedZoneCoord)) {
      availableDirections.push(0);
    }
    if (isCoordinateAvailable([lastCoord[0] + 1, lastCoord[1]], usedZoneCoord)) {
      availableDirections.push(1);
    }
    if (isCoordinateAvailable([lastCoord[0], lastCoord[1] + 1], usedZoneCoord)) {
      availableDirections.push(2);
    }
    if (isCoordinateAvailable([lastCoord[0] - 1, lastCoord[1]], usedZoneCoord)) {
      availableDirections.push(3);
    }

    switch Random.fromArray(availableDirections) {
      case 0: //UP
        zoneCoord = [lastCoord[0], lastCoord[1] - 1];
      case 1: //RIGHT
        zoneCoord = [lastCoord[0] + 1, lastCoord[1]];
      case 2: //DOWN
        zoneCoord = [lastCoord[0], lastCoord[1] + 1];
      case 3: //LEFT
        zoneCoord = [lastCoord[0] - 1, lastCoord[1]];
    }
    return zoneCoord;
  }

  private static function isCoordinateAvailable(coordinate:Array<Int>, usedZoneCoord:Array<Array<Int>>):Bool {
    if (coordinate[0] == 0 && coordinate[1] == -1) {
      return false;
    }
    
    if (coordinate[1] > 1 || coordinate[1] < -1) {
      return false;
    }

    for (coord in usedZoneCoord) {
      if(coord[0] == coordinate[0] && coord[1] == coordinate[1]){
        return false;
      }
    }
    return true;
  }

  private static function createZone(kind:ZoneKind, zoneCoord:Array<Int>, name:Int):Array<Array<Int>> {
    var ngold:Int = 0;
    var nTreasures:Int = 0;
    var nMonsters:Int = 0;
    var nWalls:Int = 0;

    switch (kind) {
      case ZoneKind.starter:
        ngold = Random.int(2, 3);
        nMonsters = Random.int(1, 2);
        nWalls = Random.int(0, 4);
      case ZoneKind.normal:
        ngold = Random.int(2, 4);
        nTreasures = Random.int(0, 2);
        nMonsters = Random.int(1, 5);
        nWalls = Random.int(3, 6);
      case ZoneKind.intense:
        ngold = Random.int(3, 5);
        nTreasures = Random.int(0, 4);
        nMonsters = Random.int(5, 8);
        nWalls = Random.int(0, 6);
    }

    var tiles = populateZone(ngold, nTreasures, nMonsters, nWalls);

    if (kind == ZoneKind.starter) tiles[0][1] = 2;

    var zoneInfo = new Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>();
    zoneInfo[ZoneInfo.nTreasures] = nTreasures;
    zoneInfo[ZoneInfo.nMonsters] = nMonsters;
    zoneInfo[ZoneInfo.ngold] = ngold;
    zoneInfo[ZoneInfo.kind] = kind;
    zoneInfo[ZoneInfo.coordX] = zoneCoord[0];
    zoneInfo[ZoneInfo.coordY] = zoneCoord[1];
    zoneInfo[ZoneInfo.name] = name;
    _zones.push(zoneInfo);

    return tiles;
  }

  public static function populateZone(ngold:Int, nTreasures:Int, nMonsters:Int, nWalls:Int):Array<Array<Int>> {
    var tiles:Array<Array<Int>> = new Array<Array<Int>>();

    var tilesArray:Array<Int> = new Array<Int>();
    while (nWalls > 0) {
      tilesArray.push(1);
      nWalls --;
    }
    while (ngold > 0) {
      tilesArray.push(3);
      ngold --;
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
