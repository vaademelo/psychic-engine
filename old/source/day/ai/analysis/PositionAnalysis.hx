package day.ai.analysis;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

import day.engine.Treasure;
import day.engine.Dungeon;
import day.engine.Unit;

enum RangeKind {
  walkRange;
  atackRange;
  visionRange;
  rawDistance;
}

class PositionAnalysis {

  public static function getUnitsInRange(dungeon: Dungeon, unit:Unit, units:FlxTypedGroup<Unit>, kind:RangeKind):Array<Unit> {
    var unitsInRange:Array<Unit> = new Array<Unit>();
    for( unitToCheck in units.members ) {
      dungeon.setTileAsWalkable(unitToCheck, true);
      var index = dungeon.getTileIndexByCoords(unitToCheck.body.getMidpoint());
      var distance = getDistance(dungeon, unit, index);
      if(distance != -1 && distance <= unit.atackRange) {
        unitsInRange.push(unitToCheck);
      }
      dungeon.setTileAsWalkable(unitToCheck, false);
    }
    return unitsInRange;
  }

  public static function getTreasuresInRange(dungeon: Dungeon, unit:Unit, treasures:FlxTypedGroup<Treasure>, kind:RangeKind):Array<Treasure> {
    var treasuresInRange:Array<Treasure> = new Array<Treasure>();
    for( treasure in treasures.members ) {
      var index = dungeon.getTileIndexByCoords(treasure.getMidpoint());
      var distance = getDistance(dungeon, unit, index);
      if(distance != -1 && distance <= unit.vision) {
        treasuresInRange.push(treasure);
      }
    }
    return treasuresInRange;
  }

  public static function getTileForAtack(dungeon:Dungeon, unit:Unit, target:Unit):Int {
    var atackRange = unit.atackRange - unit.walkRange;
    var closestPoint = unit.atackRange;
    var targetTile:Int = null;
    var index = dungeon.getTileIndexByCoords(target.body.getMidpoint());
    var tilesToCheck = dungeon.propagateOnTiles(index, atackRange);
    for (tile in tilesToCheck) {
      if(index == tile) continue;
      var distance = getDistance(dungeon, unit, tile);
      if(closestPoint == null || distance < closestPoint) {
        closestPoint = distance;
        targetTile = tile;
      }
    }

    return targetTile;
  }

  public static function getDistance(dungeon: Dungeon, unit:Unit, destination:Int):Int {
    var path = dungeon.getPath(unit.body.getMidpoint(), destination);
    if (path == null) return -1;
    return path.length - 1;
  }

  public static function getPath(dungeon: Dungeon, unit:Unit, destination:Int):Array<FlxPoint> {
    var path = dungeon.getPath(unit.body.getMidpoint(), destination);
    if (path == null) return null;
    return (path.length > unit.walkRange + 1) ? path.splice(0,unit.walkRange + 1) : path;
  }

}
