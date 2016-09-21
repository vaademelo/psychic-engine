package day.ai.analysis;

import flixel.tile.FlxBaseTilemap;

import flixel.group.FlxGroup;

import day.engine.Treasure;
import day.engine.Dungeon;
import day.engine.Unit;

import day.ai.Mind;
import day.ai.analysis.FightAnalysis;
import day.ai.analysis.PositionAnalysis;

enum ActionKind {
  exploreWorld;
  atackOponent;
  getTreasure;
  goToSafety;
  returnHome;
}

class ActionAnalysis {

  public static function calculateActions(dungeon:Dungeon, unit:Unit, heroes:FlxTypedGroup<Unit>, enemies:FlxTypedGroup<Unit>, treasures:FlxTypedGroup<Treasure>):Map<ActionKind, Dynamic> {
    var possibleActionValues:Map<ActionKind, Dynamic> = new Map<ActionKind, Dynamic>();

    var exploreOption = calculateExploreOption(dungeon, unit, treasures);
    possibleActionValues.set(exploreWorld, exploreOption);

    var otherTeamUnits = (unit.team == hero) ? enemies : heroes;
    var atackOption = calculateAtackOption(dungeon, unit, otherTeamUnits);
    possibleActionValues.set(atackOponent, atackOption);

    var treasureOption = calculateTreasureOption(dungeon, unit, treasures);
    possibleActionValues.set(getTreasure, treasureOption);

    possibleActionValues.set(goToSafety, null);
    possibleActionValues.set(returnHome, null);

    return possibleActionValues;
  }

  public static function calculateTreasureOption(dungeon:Dungeon, unit:Unit, treasures:FlxTypedGroup<Treasure>):Array<Dynamic> {
    var treasuresInRange:Array<Treasure> = PositionAnalysis.getTreasuresInRange(dungeon, unit, treasures, walkRange);
    if(treasuresInRange.length > 0) {
      var bigTreasures:List<Treasure> = Lambda.filter(treasuresInRange, function (treas) { return treas.size == big;});
      if(bigTreasures.length > 0) {
        var coordinate = dungeon.getTileIndexByCoords(bigTreasures.first().getMidpoint());
        return [3, coordinate, null];
      }
      var coordinate = dungeon.getTileIndexByCoords(treasuresInRange[0].getMidpoint());
      return [2, coordinate, null];
    } else {
      var treasuresInRange:Array<Treasure> = PositionAnalysis.getTreasuresInRange(dungeon, unit, treasures, visionRange);
      var bigTreasures:List<Treasure> = Lambda.filter(treasuresInRange, function (treas) { return treas.size == big;});
      if(bigTreasures.length > 0) {
        var coordinate = dungeon.getTileIndexByCoords(bigTreasures.first().getMidpoint());
        return [1, coordinate, null];
      }
      var coordinate = dungeon.getTileIndexByCoords(treasuresInRange[0].getMidpoint());
      return [1, coordinate, null];
    }

  }

  public static function calculateAtackOption(dungeon:Dungeon, unit:Unit, units:FlxTypedGroup<Unit>):Array<Dynamic> {
    var unitsInRange = PositionAnalysis.getUnitsInRange(dungeon, unit, units, atackRange);
    if(unitsInRange.length>0){
      return FightAnalysis.getEasiestEnemy(dungeon, unit, unitsInRange);
    }
    unitsInRange = PositionAnalysis.getUnitsInRange(dungeon, unit, units, visionRange);
    if(unitsInRange.length>0){
      return FightAnalysis.getEasiestEnemy(dungeon, unit, unitsInRange, 1);
    }
    return null;
  }

  public static function calculateExploreOption(dungeon:Dungeon, unit:Unit, treasures:FlxTypedGroup<Treasure>):Array<Dynamic> {
    var closestPoint:Int = null;
    var coordinate:Int = null;
    var unknowTiles:Array<Int> = dungeon.getTileInstances(2);
    var index = dungeon.getTileIndexByCoords(unit.body.getMidpoint());
    for (tile in unknowTiles) {
      var i = Math.abs(tile%dungeon.widthInTiles - index%dungeon.widthInTiles);
      var j = Math.abs(Math.floor(tile/dungeon.widthInTiles) - Math.floor(index/dungeon.widthInTiles));
      if(closestPoint == null || i+j < closestPoint) {
        closestPoint = Math.floor(i+j);
        coordinate = tile;
      }
    }
    if (coordinate != null) {
      var treasuresInRange:Array<Treasure> = PositionAnalysis.getTreasuresInRange(dungeon, unit, treasures, visionRange);
      var ratio = Math.ceil((closestPoint - unit.vision)/unit.walkRange);
      ratio = (ratio > 3) ? 1 : (treasuresInRange.length > 0) ? 2 : 3;
      return [ratio, coordinate, null];
    } else {
      return null;
    }
  }

}
