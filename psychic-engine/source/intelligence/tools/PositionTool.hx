package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;
import mission.world.WorldObject;

class PositionTool {

  public static function getObjectsInRange(unit:Unit, list:FlxTypedGroup<OneOfTwo<Unit, Collectable>>):Array<OneOfTwo<Unit, Collectable>> {
    var objectsInRange:Array<OneOfTwo<Unit, Collectable>> = new Array<OneOfTwo<Unit, Collectable>>();
    for (obj in list.members) {
      var ob = cast(obj, WorldObject);
      if (Math.abs(unit.i - ob.i) + Math.abs(unit.j + ob.j) <= unit.character.vision) objectsInRange.push(obj);
    }
    return objectsInRange;
  }

  public static function getValidTilesInRange(worldMap:WorldMap, unit:Unit):Array<Array<Int>> {
    var tiles:Array<Array<Int>> = new Array<Array<Int>>();
    for (i in -unit.character.vision...unit.character.vision+1) {
      var limits:Int = Std.int(unit.character.vision - Math.abs(i));
      for (j in -limits...limits+1) {
        if(worldMap.isTileValid(unit.i + i, unit.j + j)) {
          tiles.push([unit.i + i, unit.j + j]);
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
