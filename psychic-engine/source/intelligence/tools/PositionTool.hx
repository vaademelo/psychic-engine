package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;
import mission.world.WorldObject;

class PositionTool {

  public static function getObjectsInRange(list:FlxTypedGroup<OneOfTwo<Unit, Collectable>>, target:Array<Int>, range:Int):Array<OneOfTwo<Unit, Collectable>> {
    var objectsInRange:Array<OneOfTwo<Unit, Collectable>> = new Array<OneOfTwo<Unit, Collectable>>();
    for (obj in list.members) {
      if (getDistanceFromObject(obj, target) <= range) objectsInRange.push(obj);
    }
    return objectsInRange;
  }

  public static function getValidTilesInRange(worldMap:WorldMap, target:Array<Int>, range:Int):Array<Array<Int>> {
    var tiles:Array<Array<Int>> = new Array<Array<Int>>();
    for (i in -range...range+1) {
      var limits:Int = Std.int(range - Math.abs(i));
      for (j in -limits...limits+1) {
        if(worldMap.isTileValid(target[0] + i, target[1] + j)) {
          tiles.push([target[0] + i, target[1] + j]);
        }
      }
    }
    return tiles;
  }

  public static function getZoneForTile(tile:Array<Int>):Array<Int> {
    var i = Math.floor((tile[0] - WorldMap.homeTile[0])/Constants.ZONE_SIZE);
    var j = Math.floor((tile[1] - WorldMap.homeTile[1])/Constants.ZONE_SIZE);
    return [i, j];
  }

  public static function getDistanceFromObject(target:OneOfTwo<Unit, Collectable>, start:Array<Int>):Int {
    if(!cast(target, WorldObject).alive) return 100;
    var destination = cast(target, WorldObject).getCoordinate();
    return Std.int(Math.abs(start[0] - destination[0]) + Math.abs(start[1] - destination[1]));
  }

  public static function getDistance(worldMap:WorldMap, start:Array<Int>, destination:Array<Int>):Int {
    var path = worldMap.getPath(start, destination);
    if (path == null) return -1;
    return path.length - 1;
  }

  public static function getDumbDistance(start:Array<Int>, destination:Array<Int>):Int {
    return Math.round(Math.abs(start[0] - destination[0]) + Math.abs(start[1] - destination[1]));
  }

}
