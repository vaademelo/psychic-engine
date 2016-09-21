package day.ai;

import flixel.group.FlxGroup;

import day.engine.Treasure;
import day.engine.Dungeon;
import day.engine.Unit;

import day.ai.Mind;
import day.ai.analysis.FightAnalysis;
import day.ai.analysis.ActionAnalysis;
import day.ai.analysis.PositionAnalysis;

class BasicEnemyAi implements Mind {

  public var action:ActionKind;
  public var walkTo:Int;
  public var target:Dynamic;

  public function new() {
  }

  public function chooseAction(dungeon:Dungeon, unit:Unit, heroes:FlxTypedGroup<Unit>, enemies:FlxTypedGroup<Unit>, treasures:FlxTypedGroup<Treasure>) {
    var heroesInRange = PositionAnalysis.getUnitsInRange(dungeon, unit, heroes, atackRange);
    if( heroesInRange.length > 0 ) {
      var atackStats = FightAnalysis.getEasiestEnemy(dungeon, unit, heroesInRange);
      this.walkTo = atackStats[1];
      this.target = atackStats[2];
      this.action = atackOponent;
    } else {
      this.walkTo = chooseRandomWalk(dungeon, unit);
      this.target = null;
      this.action = exploreWorld;
    }
    if(walkTo != null) {
      var path = PositionAnalysis.getPath(dungeon, unit, walkTo);
      if(path != null) {
        unit.body.gotoTile(path);
      }
    }
  }

  public function chooseRandomWalk(dungeon:Dungeon, unit:Unit):Int {
    var index = dungeon.getTileIndexByCoords(unit.body.getMidpoint());
    var tiles = dungeon.propagateOnTiles(index, unit.walkRange);
    for (i in 0...3) {
      var tile = Random.fromArray(tiles);
      var path = dungeon.getPath(unit.body.getMidpoint(), tile);
      if (path != null && path.length <= unit.walkRange + 1) {
        return tile;
      }
    }
    return null;
  }

}
