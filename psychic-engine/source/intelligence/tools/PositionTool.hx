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
      var ob = cast(obj, WorldObject);
      if (Math.abs(target[0] - ob.i) + Math.abs(target[1] + ob.j) <= range) objectsInRange.push(obj);
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

  public static function getDistance(worldMap:WorldMap, start:Array<Int>, destination:Array<Int>):Int {
    var path = worldMap.getPath(start, destination);
    if (path == null) return -1;
    return path.length - 1;
  }

}
