package intelligence.monster;

import Random;

import flixel.group.FlxGroup;

import intelligence.Mind;
import intelligence.tools.PositionTool;

import mission.world.Unit;
import mission.world.WorldMap;
import mission.world.WorldObject;

import utils.Constants;

class MonsterMind implements Mind {

  public function new() {
  }

  public function analyseAction(worldMap:WorldMap, unit:Unit):Array<Int> {
    var opponents = (unit.character.team == TeamSide.heroes) ? worldMap.monsters : worldMap.heroes;
    var opponentsInRange = PositionTool.getObjectsInRange(opponents, unit.getCoordinate(), unit.character.vision);

    if (opponentsInRange.length > 0) {
      return chooseOpponentToAtack(opponentsInRange);
    } else {
      return chooseRandomTileToWalk(worldMap, unit);
    }
  }

  public function chooseOpponentToAtack(opponents:Array<Unit>):Array<Int> {
    //TODO: choose easiest opponent
    return Random.fromArray(opponents).getCoordinate();
  }

  public function chooseRandomTileToWalk(worldMap:WorldMap, unit:Unit):Array<Int> {
    var validTiles:Array<Array<Int>> = PositionTool.getValidTilesInRange(worldMap, unit.getCoordinate(), unit.character.vision);
    var tile = Random.fromArray(validTiles);
    return tile;
  }
}
